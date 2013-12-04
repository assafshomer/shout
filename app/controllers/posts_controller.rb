class PostsController < ApplicationController

  before_filter :no_edit, only: [:edit,:update]
  before_filter :set_location

  def new
    @title=new_title
    @post=Post.new 
    @posts=Post.publication_tail
    @zoom="minioutput"
  end

  def create
    # binding.pry
    @title=new_title
  	@post=Post.new(post_params)
    @post.location=@location
    @posts=Post.publication_tail
    @zoom="minioutput"    
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
    @zoom="minioutput"
  end

  def update
    @title=edit_title
    @post=Post.find(params[:id])
    @post.location=@location
    @posts=Post.publication_tail
    @zoom="minioutput"    
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
    @zoom="superminioutput"
    @all_posts=Post.published.to_a
    @search_results=search_stream(params[:search], Post.published)
    @local_search=local_stream(@location, Post.published) 
    set_tile_count
    # set_zoom unless params[:search].nil?  
    @posts=@search_results.paginate(page: params[:search_page], 
      per_page: @count).order('created_at DESC')
    @local_posts=@local_search.paginate(page: params[:local_page], 
      per_page: 10).order('created_at DESC') unless @local_posts.nil?
    redirect_to posts_path if params[:commit]=='Clear'
  end

	private

	  def post_params
      params.require(:post).permit(:content)
    end

    def search_stream(space_separated_search_terms, stream)    
      if !space_separated_search_terms.blank?      
        stream.where(generate_LIKE_sql(space_separated_search_terms, 'content location',Post))
      else
        stream
      end
    end

    def local_stream(space_separated_search_terms, stream) 
      if !space_separated_search_terms.blank?      
        stream.where(generate_LIKE_sql(space_separated_search_terms, 'location',Post))
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

    def set_zoom
      @zoom = "smalloutput" 
      @count = search_tile_count
    end

    def set_tile_count
      if @local_posts.nil?
        @count = tile_count * 2
      else
        @count = tile_count 
      end
    end

end