module ViewsHelper
	def preview_button_title
		# app_title
		"Preview"
	end

	def publish_button_title
		# app_title
		"Post"
	end

	def button_space
		' '*20
	end

	def app_title
		'bilbox'
	end

	def full_title(string)
		app_title + " - " + string
	end

	def app_mantra
		'...think inside the box...'
	end

	def post_place_holder
		"try it, it`s fun"
	end

	def feed_title
		'stream'
	end

	def fake_content
		content=''
		(1..10).to_a.sample.times do
			content += Faker::Lorem.sentence
			content += ' '
		end
		content[0..content.length-2]
	end

	def home_title
		'Post'
	end
	
	def tile_title
		'Watch'
	end

	def tile_count
		if Rails.env == 'test'
			10
		else
			189 #21 rows X 9 cols	
		end		
	end

	def cheatsheet_text
		"...limited to within the box..."
	end

	def search_tile_count
		if Rails.env == 'test'
			5
		else
			15 
		end		
	end



end