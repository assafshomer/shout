namespace :db do
	desc "fill database with sample posts"
	task populate: :environment do 		
		make_posts		
	end

	def make_posts		
		number_of_posts=500			
		number_of_posts=(ViewsHelper::tile_count * 3) if Rails.env="test"
		number_of_posts.times do 			
			hours_created_ago=rand(1..100)
			blurb=''
			(1..10).to_a.sample.times do
				blurb += Faker::Lorem.sentence.to_s
				blurb += ' '
			end
			blurb=blurb[0..blurb.length-2]			
			blurb="short post" unless blurb.length>5
			post=Post.create!(content: blurb, 
				created_at: hours_created_ago.hour.ago, published: true)
		end
	end
	
end