class PostsController < ApplicationController
  def new
  	@post=Post.new 
  end

  def create
    # binding.pry
  	@post=Post.new(post_params)
    if @post.save
      fork(@post)
    else
      render 'new'      
    end
  end 

  def edit
    @post=Post.find(params[:id])
  end

  def update
    @post=Post.find(params[:id])
    if @post.update_attributes(post_params)
      fork(@post)
    else
      render 'edit'      
    end
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

    def fork(post)
      if params[:commit]=="Preview"
        redirect_to edit_post_path(post)
      else
        # post.toggle!(:published)
        flash[:success] = "Thanks for sharing"                
        redirect_to root_path      
      end
    end

end