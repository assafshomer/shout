module MarkupHelper

  BACKTICK_REGEX = /`\d+\s+[^\s]{1}[^`]*`{1}/
  BACKTICK_GROUPED = /(`)(\d+)(\s+)([^\s]{1}[^`]*)(`{1})/
  PRE='<div class=mark style=font-size:'  

  def extract_backticks(string)
    string.scan(BACKTICK_REGEX)
  end

  def extract_compliment(string)
    string.split(BACKTICK_REGEX).reject(&:empty?)
  end

  def stitch(array1,array2)
    size=[array1.size,array2.size].max
  end

  def markup(string)
    string.gsub(BACKTICK_GROUPED,'<div class=mark style=font-size:\2em;>\4</div>')
  end

  def mark_and_pulverize(string)
    string.gsub(BACKTICK_GROUPED) do |match|
      PRE+$2+"em;>"+pulverize($4)+'</div>'
    end
  end

  def pulverize(string)
    string.gsub(/(\w)/,'\0&#8203;')
  end

  def prepare(string)
    # sanitize(string.split.join(" "))
    # sanitize(string)
    strip_tags(string)
  end

end
