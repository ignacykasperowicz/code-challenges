require 'set'

class Parser
  attr_accessor :sourced, :mapped, :reversed, :filtered

  def initialize
    @sourced = []
    @mapped = []
    @reversed = {}
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
      unless split.empty?
        split.each do |e|
          @mapped << [word, e]
        end
      end
    end
  end

  def reverse
    @mapped.map!(&:reverse)
    mapped.each do |pair|
      @reversed[pair.first] = [] unless @reversed[pair.first]
      @reversed[pair.first] << pair.last
    end
  end

  def filter
    reversed.each do |key, value|
      @filtered[key] = value unless value.size > 1
    end
  end

  def save
    sequences = filtered.keys
    words = filtered.values.flatten
    File.open('words.txt', 'w') { |file| file.puts(words) }
    File.open('sequences.txt', 'w') { |file| file.puts(sequences) }
  end
end

parser = Parser.new
parser.parse
