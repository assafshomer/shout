class SessionsController < ApplicationController

	def new
		@title=full_title(signin_title)
		@location=cookies[:location] || 'unknown'
	end
	
	def create
		@title=full_title(signin_title)
		@location=params[:location] || 'unknown'
		cookies[:location]=@location 
		redirect_to root_path
	end

end
