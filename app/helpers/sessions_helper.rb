module SessionsHelper

	def set_location
	  @location=cookies[:location]
	  @location=nil if @location.blank?
	end

end
