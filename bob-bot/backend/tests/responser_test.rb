require 'minitest/autorun'
require_relative '../lib/responser'

class TestResponses < Minitest::Test
  def setup
    @responser = Responser.new
  end

  def test_question_message
    assert_equal "Sure", @responser.get_answer('foobar?')
  end

  def test_question_mark_message
    assert_equal "Whatever", @responser.get_answer('?foobar')
  end

  def test_uppercase_message
    assert_equal "Woah, chill out!", @responser.get_answer('FOOBAR BARFOO')
  end

  def test_empty_message
    assert_equal "Fine. Be that way!", @responser.get_answer('')
  end

  def test_not_matched_message
    assert_equal "Whatever", @responser.get_answer('foobar FDFDF')
  end
end