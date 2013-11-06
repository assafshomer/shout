class SessionsController < ApplicationController

	def new
		@title=full_title(signin_title)
	end
	
end
