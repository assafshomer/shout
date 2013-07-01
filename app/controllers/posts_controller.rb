class PostsController < ApplicationController
  def new    
  	@post=Post.new       
    @posts=search_stream(params[:search], Post.all)
    redirect_to root_path if params[:commit]=='Clear'
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
    @posts=search_stream(params[:search], Post.all)
    redirect_to posts_path if params[:commit]=='Clear'
  end

	private

	  def post_params
      params.require(:post).permit(:content)
    end

  def search_stream(space_separated_search_terms, stream)    
    if !space_separated_search_terms.blank?      
      stream.where(generate_LIKE_sql(space_separated_search_terms, 'content',Post))
    else
      stream
    end
  end      
end
