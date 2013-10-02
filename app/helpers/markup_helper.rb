module MarkupHelper
include PostsHelper

  BACKTICK_REGEX = /`\d+\s+[^\s]{1}[^`]*`{1}/
  BACKTICK_EMPTY = /`\d+\s+`{1}/
  BACKTICK_GROUPED = /(`)(\d+)(\s+)([^\s]{1}[^`]*)(`{1})/
  PRE='<div class=mark style=font-size:'  
  ZWSP='&#8203;'

  def extract_backticks(string)
    string.scan(BACKTICK_REGEX).reject {|s| s=~BACKTICK_EMPTY}
  end

  def extract_compliment(string)
    string.split(BACKTICK_REGEX).reject(&:empty?).reject {|s| s=~BACKTICK_EMPTY}
  end

  def markup(string)
    string.gsub(BACKTICK_GROUPED,PRE+'\2em;>\4</div>')
  end

  def mark(string)
    full_process=extract_backticks(string).map {|s| mark_and_pulverize(s)}
    only_pulverize=extract_compliment(string).map {|s| pulverize(s)}
    result=nil
    if string[0]=='`' && string[1]!='`'
      result=ArrayStitcher.new(full_process,only_pulverize)
    else
      result=ArrayStitcher.new(only_pulverize,full_process)
    end
    replace_newline_with_br(result.stitch.join)
  end

  def mark_and_pulverize(string)
    string.sub(BACKTICK_GROUPED) do |match|
      PRE+$2+"em;>"+pulverize($4)+'</div>'
    end
  end

  def pulverize(string,char=ZWSP)
    string.gsub(/(\S)/,'\0'+char)
  end

  def prepare(string)
    strip_tags(string)
  end

end
