module PostsHelper

  def max_length
    67 
    #this seems to be the number of medium size a's that fit into 40em textarea width
  end
  def new_wrap(content)    
    array=replace_newline_with_br(content).split
    new_array=array.map do |string|
      smart_wrap(string)
    end
    sanitize(new_array.join(' '))
  end

  def wrap(content)    
    array=replace_newline_with_br(content).split
    new_array=array.map do |string|
      smart_wrap(string)
    end
    raw(new_array.join(' '))
  end

  def replace_newline_with_br(string)
    string.strip.gsub("\r\n","<br/>").gsub("\n", "<br/>").gsub("\r","<br/>")
  end

  def wrap_long_string(text, width = max_length)
    zero_width_space = "&#8203;"
    regex = /.{1,#{width}}/
    (text.length < width) ? text : 
                                text.scan(regex).join(zero_width_space)
  end

  def smart_wrap(text)
    array=text.split("<br/>")
    new_array =  array.map do |string|
      wrap_long_string(string)
    end
    new_array.join("<br/>")
  end  

  private



end
