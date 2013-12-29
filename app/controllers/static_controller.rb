class StaticController < ApplicationController
  
  before_filter :set_location

  def home
  	@title="Home"
    # @post=Post.new 
    # @posts=Post.publication_tail
    # @zoom="small"
  end

  def help
  	@title="Help"
  end

  def shapes
    @title=shapes_title
    @rows=7
    @columns=15
    Rails.env=='test'?per_page=3:per_page=@rows*@columns
    @ascii_array=ascii_array.paginate(page: params[:page], per_page: per_page, total_pages: 100)
  end  

  def about
  	@title="About"
    @small_text_example=Post.where('content LIKE "%Bob%Dylan%Hurricane%"')[0].id
  end

  def contact
  	@title="Contact"
  end
end
