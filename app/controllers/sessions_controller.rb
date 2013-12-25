class SessionsController < ApplicationController

	def new
		@title=full_title(signin_title)
		@location=cookies[:location] 
	end
	
	def create
		@title=full_title(signin_title)
		@location=params[:location]
		cookies[:location]=@location 
		redirect_to root_path
	end

end
