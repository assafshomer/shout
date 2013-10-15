module ViewsHelper
	def preview_button_title
		# app_title
		"Preview"
	end

	def publish_button_title
		# app_title
		"Publish"
	end

	def button_space
		' '*20
	end

	def app_title
		'bilbox'
	end

	def app_mantra
		'...think inside the box...'
	end

	def post_place_holder
		"think inside the box"
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
		'Contribute'
	end
	
	def tile_title
		'Watch'
	end

	def tile_size
		10
	end

end