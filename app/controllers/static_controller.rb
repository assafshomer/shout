class StaticController < ApplicationController
  def home
  	@title="Home"
    @post=Post.new 
    @posts=Post.last(24).sort.reverse
    @zoom="superminioutput"
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
