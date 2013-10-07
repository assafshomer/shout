module MarkupHelper
include PostsHelper

  BACKTICK_REGEX = /`\d+\s+[^\s]{1}[^`]*`{1}/
  BACKTICK_EMPTY = /`\d+\s+`{1}/
  BACKTICK_GROUPED = /(`)(\d+)(\s{1})(\s*[^\s]{1}[^`]*)(`{1})/
  PRE='<div class=mark style=font-size:'  
  ZWSP='&#8203;'
  URL_REGEX = /https?:[\/|\\]{2}[[A-Za-z]|\d|\.|\\|\/]+/
  MARKED_URL = /(\s*\S+\s*)\|{1}(\s*https?:[\/|\\]{2}[[A-Za-z]|\d|\.|\\|\/]+)/

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
    '<pre>'+result.stitch.join+'</pre>'
  end

  def mark_and_pulverize(string)
    string.sub(BACKTICK_GROUPED) do |match|
      PRE+$2+"em;>"+pulverize($4)+'</div>'
    end
  end

  def pulverize(string,char=ZWSP)
    string.gsub(/(\S)/,'\0'+char)
  end

  def match_url(string)
    string.scan(URL_REGEX)
  end

  def match_marked_url(string)
    string.scan(MARKED_URL).each do |matched_array|
      matched_array.map!(&:strip)
    end
  end

  def marked_urls(string)
    temp=[]
    result=[]
    string.scan(MARKED_URL).each do |matched_array|
      temp << matched_array.map(&:strip)
    end
    temp.each do |url_building_blocks|
      result << '<a href='+url_building_blocks[1]+'>'+url_building_blocks[0]+'</a>'
    end
    result
  end  

end