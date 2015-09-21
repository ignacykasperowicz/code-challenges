class Parser
  attr_accessor :sourced, :mapped, :reversed, :filtered

  WINDOW_SIZE = 4

  def initialize
    @sourced = []
    @mapped = []
    @reversed = Hash.new { |h, k| h[k] = [] }
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
    @sourced = File.foreach('dictionary.txt').inject([]) { |arr, line| arr << line.strip }
  end

  def split(word)
    (0..word.length - WINDOW_SIZE).inject([]) { |ret, index| ret << word[index..index + WINDOW_SIZE - 1] }
  end

  def map
    sourced.each do |word|
      split = split(word)
      split.each { |sequence| @mapped << [word, sequence] } unless split.empty?
    end
  end

  def reverse
    mapped.map(&:reverse).each { |pair| @reversed[pair.first] << pair.last }
  end

  def filter
    reversed.each { |sequence, words| @filtered[sequence] = words.flatten unless words.size > 1 }
  end

  def save
    File.open('words.txt', 'w') { |file| file.puts(filtered.values) }
    File.open('sequences.txt', 'w') { |file| file.puts(filtered.keys) }
  end
end

Parser.new.parse
