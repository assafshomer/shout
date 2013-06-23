module ViewsHelper
	def submit_button_title
		# app_title
		app_title.downcase
	end

	def button_space
		' '*20
	end

	def app_title
		'Speak UP'
	end

	def app_mantra
		'...think inside the box...'
	end

	def post_place_holder
		"			...think inside the box..."
	end

	def feed_title
		'stream'
	end
end