class PostsController < ApplicationController
  def new    
  	@post=Post.new   
    @posts=Post.all.to_a
  end

  def create
  	@post=Post.new(post_params)
    @posts=Post.all.to_a    
    if @post.save
      flash[:success] = "Thanks for sharing"  	            
      redirect_to root_path
    else
  	  render 'new'
    end
  end

  def index
    @posts=Post.all.to_a
  end

	private

	  def post_params
      params.require(:post).permit(:content)
    end  
end
