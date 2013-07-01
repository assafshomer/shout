namespace :db do
	desc "fill database with sample posts"
	task populate: :environment do 		
		make_posts		
	end

	def make_posts		
		number_of_posts=50			
		number_of_posts.times do |blurb|
			number_of_lines=rand(1..15)
			hours_created_ago=rand(1..100)
			blurb=Faker::Lorem.sentence(number_of_lines)
			blurb="short post" unless blurb.length>5
			post=Post.create!(content: blurb, created_at: hours_created_ago.hour.ago)
		end
	end
	
end