class PostsController < ApplicationController
  def new
  	@post=Post.new 
    redirect_to root_path if params[:commit]=='Clear'
  end

  def create
    # binding.pry
  	@post=Post.new(post_params)
    if @post.save
      flash[:success] = "Thanks for sharing"  	            
      redirect_to root_path
    else
  	  render 'new'
    end
  end 

  def edit
    @post=Post.new(post_params)
  end

  def show
    @post=Post.find(params[:id]) 
  end

  def index 
    @all_posts=Post.all.to_a
    @search_results=search_stream(params[:search], Post.all)
    @posts=@search_results.paginate(page: params[:page],
     per_page: tile_size).order('created_at DESC')
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

  def process(post)
    
  end
end