class StaticController < ApplicationController
  def home
  	@title="Home"
    @location=cookies[:location] || 'unknown'
    @post=Post.new 
    @posts=Post.publication_tail
    @zoom="minioutput"
  end

  def help
    @location=cookies[:location] || 'unknown'
  	@title="Help"
  end

  def shapes
    @location=cookies[:location] || 'unknown'
    @title=shapes_title
    @rows=7
    @columns=15
    Rails.env=='test'?per_page=3:per_page=@rows*@columns
    @ascii_array=ascii_array.paginate(page: params[:page], per_page: per_page, total_pages: 100)
  end  

  def about
    @location=cookies[:location] || 'unknown'
  	@title="About"
  end

  def contact
    @location=cookies[:location] || 'unknown'
  	@title="Contact"
  end
end
