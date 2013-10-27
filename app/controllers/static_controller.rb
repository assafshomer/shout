class StaticController < ApplicationController
  def home
  	@title="Home"
    @post=Post.new 
  end

  def help
  	@title="Help"
  end

  def about
  	@title="About"
  end

  def contact
  	@title="Contact"
  end
end
