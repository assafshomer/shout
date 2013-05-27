class PostsController < ApplicationController
  def new    
  	@post=Post.new    
  end

  def create
  	@post=Post.new(post_params)
    if @post.save
      flash[:success] = "Thanks for sharing"  	            
      redirect_to root_path
    else
  	  render 'new'
    end
  end

	private
	  def post_params
      params.require(:post).permit(:content)
    end  
end
