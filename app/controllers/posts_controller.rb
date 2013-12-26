class PostsController < ApplicationController

  before_filter :no_edit, only: [:edit,:update]
  before_filter :set_location

  def new
    @title=new_title
    @post=Post.new 
    @posts=Post.publication_tail
    @zoom="small"
  end

  def create
    # binding.pry
    @title=new_title
  	@post=Post.new(post_params)
    @post.location=@location
    @posts=Post.publication_tail
    @zoom="small"    
    if @post.save
      fork(@post)
    else
      render 'new'      
    end
  end 

  def edit
    @title=edit_title
    @post=Post.find(params[:id])
    @post.location=@location
    @posts=Post.publication_tail
    @zoom="small"
  end

  def update
    @title=edit_title
    @post=Post.find(params[:id])
    @post.location=@location
    @posts=Post.publication_tail
    @zoom="small"    
    if @post.update_attributes(post_params)
      fork(@post)
    else
      render 'edit'      
    end
  end 

  def show
    @title=show_title
    @post=Post.find(params[:id]) 
  end

  def index 
    @title=index_title
    @search_zoom="tiny"
    @local_zoom="tiny"
    @all_posts=Post.published.to_a
    @search_results=search_stream(params[:search], Post.published)
    @local_results=local_stream(@location, Post.published) 
    # binding.pry
    @search_count=set_tile_count(@location)
    @local_count=@search_count
    # set_search_zoom unless params[:search].nil?
    @posts=@search_results.paginate(page: params[:search_page], 
      per_page: @search_count).order('created_at DESC')
    @local_posts=@local_results.paginate(page: params[:local_page], 
      per_page: @local_count).order('created_at DESC') unless @local_results.nil?
    redirect_to posts_path if params[:commit]=='Clear'
  end

	private

	  def post_params
      params.require(:post).permit(:content)
    end

    def search_stream(space_separated_search_terms, stream)    
      if !space_separated_search_terms.blank?      
        stream.where(generate_sql(space_separated_search_terms, 'content location',Post))
      else
        stream
      end
    end

    def local_stream(location, stream) 
      if !location.blank?      
        stream.where(generate_exact_sql(location, 'location',Post))
      end
    end  

    def fork(post)
      if params[:commit]==preview_button_title
        redirect_to edit_post_path(post)
      else
        post.toggle!(:published) unless post.published
        flash[:success] = "Thanks for sharing"                
        redirect_to new_post_path      
      end
    end

    def no_edit
      post = Post.find_by_id(params[:id])
      redirect_to new_post_path if post.nil? || post.published? 
    end

    def set_search_zoom
      @search_zoom = "medium" 
      @search_count = 4
    end

    def set_tile_count(location)
      if location.blank?
        return tile_count(1)
      else
        return tile_count(2)
      end
    end

end