namespace :db do
	desc "fill database with sample posts"
	task populate: :environment do 		
		make_posts		
	end

	desc "create example posts"
	task examples: :environment do 		
		create_examples
	end

	def create_examples		
		Post.create!(content: "Check out this `2 cool` shape:\r\n\r\n\r\n\r\n`22 ௵`",
		 published: true, location: 'The Internets')
		Post.create!(content: "      `50 Y`",published: true, location: 'The Internets')			
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