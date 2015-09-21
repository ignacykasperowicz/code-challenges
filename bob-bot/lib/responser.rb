class Responser
  def get_answer(msg)
    h = {
      'Sure' => question?(msg),
      'Woah, chill out!' => capitals?(msg),
      'Fine. Be that way!' => msg.empty?,
      'Whatever' => not_matched?(msg)
    }
    h.key(true)
  end

  private

  def question?(msg)
    !!(msg =~ /\?$/)
  end

  def capitals?(msg)
    !!(msg =~ /^[A-Z]+$/)
  end

  def not_matched?(msg)
    !question?(msg) && !capitals?(msg) && !msg.empty?
  end
end