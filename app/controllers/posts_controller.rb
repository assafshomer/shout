class PostsController < ApplicationController

  before_filter :no_edit, only: [:edit,:update]

  def new
    @title="Home"
  	@post=Post.new 
  end

  def create
    # binding.pry
    @title="Home"
  	@post=Post.new(post_params)
    if @post.save
      fork(@post)
    else
      render 'new'      
    end
  end 

  def edit
    @title="Preview"
    @post=Post.find(params[:id])
  end

  def update
    @title="Preview"
    @post=Post.find(params[:id])
    if @post.update_attributes(post_params)
      fork(@post)
    else
      render 'edit'      
    end
  end 

  def show
    @title="Show"
    @post=Post.find(params[:id]) 
  end

  def index 
    @title="Watch"
    @zoom="superminioutput"
    @count=tile_count
    @all_posts=Post.published.to_a
    @search_results=search_stream(params[:search], Post.published)
    set_zoom unless params[:search].nil?  
    @posts=@search_results.paginate(page: params[:page],
     per_page: @count).order('created_at DESC')    
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

    def fork(post)
      if params[:commit]=="Preview"
        redirect_to edit_post_path(post)
      else
        post.toggle!(:published) unless post.published
        flash[:success] = "Thanks for sharing"                
        redirect_to root_path      
      end
    end

    def no_edit
      post = Post.find_by_id(params[:id])
      redirect_to root_path if post.nil? || post.published? 
    end

    def set_zoom
      @zoom = "smalloutput" 
      @count = search_tile_count
    end

end