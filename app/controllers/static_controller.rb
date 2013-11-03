class StaticController < ApplicationController
  def home
  	@title="Home"
    @post=Post.new 
    @posts=Post.publication_tail
    @zoom="minioutput"
  end

  def help
  	@title="Help"
  end

  def shapes
    @title=shapes_title
    @ascii_array=ascii_array
  end  

  def about
  	@title="About"
  end

  def contact
  	@title="Contact"
  end
end
