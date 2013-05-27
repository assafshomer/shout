class PostsController < ApplicationController
  def new
  	@post=Post.new
  end

  def create
  end

	private
	  def post_params
      params.require(:post).permit(:content)
    end  
end
