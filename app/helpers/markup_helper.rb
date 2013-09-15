module MarkupHelper

  def find_backticks(string)
    string.scan(/`\d+\s[^\s][^`]+`{1}/)
  end


  private



end
