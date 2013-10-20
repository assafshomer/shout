module MarkupHelper
include PostsHelper

  BACKTICK_REGEX = /`\d+\s+[^`]*`{1}/
  BACKTICK_EMPTY = /`\d+\s`{1}/
  BACKTICK_GROUPED = /(`)(\d+)(\s{1})([^`]*)(`{1})/
  PRE='<div class=mark style=font-size:'  
  ZWSP='&#8203;'
  URL_REGEX = /https?:[\/|\\]{2}[[A-Za-z]|\d|\.|\\|\/|-]+/
  MARKED_URL = /([^|]+)\|{1}(\s*https?:[\/|\\]{2}[[A-Za-z]|\d|\.|\\|\/]+)/

  def extract_backticks(string)
    string.scan(BACKTICK_REGEX).reject {|s| s=~BACKTICK_EMPTY}
  end

  def extract_compliment(string)
    string.split(BACKTICK_REGEX).reject(&:empty?).reject {|s| s=~BACKTICK_EMPTY}
  end

  def markup(string)
    string.gsub(BACKTICK_GROUPED,PRE+'\2em;>\4</div>')
  end

  def mark(string, type="show")
    full_process=extract_backticks(string).map {|s| process(s, type)}
    only_pulverize=extract_compliment(string).map {|s| pulverize(s)}
    result=nil
    if string[0]=='`' && string[1]!='`'
      result=ArrayStitcher.new(full_process,only_pulverize)
    else
      result=ArrayStitcher.new(only_pulverize,full_process)
    end    
    '<pre>'+result.stitch.join+'</pre>'
  end

  def process(string, type="show")
    if type=="show"
      string.sub(BACKTICK_GROUPED) do |match|
        PRE+$2+"em;>"+link_and_pulverize($4)+'</div>'
      end      
    else
      string.sub(BACKTICK_GROUPED) do |match|
        PRE+$2+"em;>"+unlink_and_pulverize($4)+'</div>'
      end      
    end
  end

  def link_and_pulverize(string)
    match=MARKED_URL.match(string)
    if !match
      pulverize(string)
    else
      pulverize(match.pre_match)+
      match[0].gsub(MARKED_URL) {|match| "<a href="+$2+">"+pulverize($1)+"</a>"}+
      pulverize(match.post_match)
    end
  end 

  def unlink_and_pulverize(string)
    match=MARKED_URL.match(string)
    if !match
      pulverize(string)
    else
      pulverize(match.pre_match)+
      match[0].gsub(MARKED_URL) {|match| pulverize($1)}+
      pulverize(match.post_match)
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




end