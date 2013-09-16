module MarkupHelper

  BACKTICK_REGEX = /`\d+\s+[^\s][^`]+`{1}/
  BACKTICK_GROUPED = /(`)(\d+)(\s+)([^\s]{1}[^`]*)(`{1})/

  def extract_backticks(string)
    string.scan(BACKTICK_REGEX)
  end

  def markup(string)
    string.gsub(BACKTICK_GROUPED,'<div style=font-size:\2em;line-height:0.8em;>\4</div>')
  end


  private



end
