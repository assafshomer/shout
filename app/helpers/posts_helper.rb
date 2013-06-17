module PostsHelper

  def new_wrap(content)    
    array=replace_newline_with_br(content).split
    new_array=array.map do |string|
      smart_wrap(string)
    end
    sanitize(new_array.join(' '))
  end

  def replace_newline_with_br(string)
    result=string.strip.gsub("\r\n","<br/>").gsub("\n", "<br/>").gsub("\r","<br/>")
  end

  def wrap_long_string(text, max_width = 30)
    zero_width_space = "&#8203;"
    regex = /.{1,#{max_width}}/
    (text.length < max_width) ? text : 
                                text.scan(regex).join(zero_width_space)
  end

  def smart_wrap(text, max_width = 30)
    array=text.split("<br/>")
    new_array =  array.map do |string|
      wrap_long_string(string)
    end
    new_array.join("<br/>")
  end  

  private



end
