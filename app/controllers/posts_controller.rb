class PostsController < ApplicationController
  def new
  	@post=Post.new
  end

  def create
  	@post=Post.new(post_params)  	
  	render 'new' unless @post.save
  end

	private
	  def post_params
      params.require(:post).permit(:content)
    end  
end
