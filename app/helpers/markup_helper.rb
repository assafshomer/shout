module MarkupHelper

  BACKTICK_REGEX = /`\d+\s+[^\s][^`]+`{1}/
  BACKTICK_GROUPED = /(`)(\d+)(\s+)([^\s]{1}[^`]*)(`{1})/

  def extract_backticks(string)
    string.scan(BACKTICK_REGEX)
  end

  def markup(string)
    string.gsub(BACKTICK_GROUPED,'<div style=font-size:\2em;line-height:0.8em;>\4</div>')
  end

  def mark_and_pulverize(string)
    string.gsub(BACKTICK_GROUPED) do |match|
      "<div style=font-size:"+$2+"em;line-height:0.8em;>"+pulverize($4)+'</div>'
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
