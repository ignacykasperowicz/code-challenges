class Parser
  attr_accessor :sourced, :mapped, :reversed, :filtered

  def initialize
    @sourced = []
    @mapped = []
    @reversed = Hash.new {|h,k| h[k]=[]}
    @filtered = {}
  end

  def parse
    read
    map
    reverse
    filter
    save
  end

  private

  def read
    @sourced = File.foreach('dictionary.txt').inject([]) { |r, l| r << l.strip }
  end

  def split word
    (0..word.length - 4).inject([]) { |ret,index| ret << word[index..index + 3] }
  end

  def map
    sourced.each do |word|
      split = split(word)
      split.each { |e| @mapped << [word, e] } unless split.empty?
    end
  end

  def reverse
    mapped.map(&:reverse).each do |pair|
      @reversed[pair.first] << pair.last
    end
  end

  def filter
    reversed.each do |key, value|
      @filtered[key] = value unless value.size > 1
    end
  end

  def save
    File.open('words.txt', 'w') { |file| file.puts(filtered.values.flatten) }
    File.open('sequences.txt', 'w') { |file| file.puts(filtered.keys) }
  end
end

parser = Parser.new
parser.parse
