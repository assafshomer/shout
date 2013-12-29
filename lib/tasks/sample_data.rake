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
		Post.create!(content: "`10   Dylan` \r\n\r\n`5\r\n\r\n           is`\r\n`15  God`",
			published: true, location: 'Duluth')		
		Post.create!(content: "A web service that inspired bilbox:\r\n\r\n`5 I ♥ Twitter | http://www.twitter.com`", 
			published: true, location: 'Tel-Aviv')	
		Post.create!(content: "`3 Bob Dylan – Hurricane`\r\n\r\nPistols shots ring out in the barroom night\r\nEnter Patty Valentine from the upper hall\r\nShe sees the bartender in a pool of blood\r\nCries out \"My God they killed them all\"\r\nHere comes the story of the Hurricane\r\nThe man the authorities came to blame\r\nFor something that he never done\r\nPut him in a prison cell but one time he could-a been\r\nThe champion of the world.\r\n\r\nThree bodies lying there does Patty see\r\nAnd another man named Bello moving around mysteriously\r\n\"I didn't do it\" he says and he throws up his hands\r\n\"I was only robbing the register I hope you understand\r\nI saw them leaving\" he says and he stops\r\n\"One of us had better call up the cops\"\r\nAnd so Patty calls the cops\r\nAnd they arrive on the scene with their red lights flashing\r\nIn the hot New Jersey night.\r\n\r\nMeanwhile far away in another part of town\r\nRubin Carter and a couple of friends are driving around\r\nNumber one contender for the middleweight crown\r\nHad no idea what kinda shit was about to go down\r\nWhen a cop pulled him over to the side of the road\r\nJust like the time before and the time before that\r\nIn Patterson that's just the way things go\r\nIf you're black you might as well not shown up on the street\r\n'Less you wanna draw the heat.\r\n\r\nAlfred Bello had a partner and he had a rap for the corps\r\nHim and Arthur Dexter Bradley were just out prowling around\r\nHe said \"I saw two men running out they looked like middleweights\r\nThey jumped into a white car with out-of-state plates\"\r\nAnd Miss Patty Valentine just nodded her head\r\nCop sai",
			published: true, location: 'Duluth')
		Post.create!(content: "If you wrap a piece of text with backticks immediately followed by a number the text you write will appear that much bigger.\r\n\r\nFor example:\r\n\r\n`3 3 times bigger`\r\n\r\n`10 tenfold`\r\n\r\nSince this is the internet, you can link using a pipe, for example: \r\n\r\n`1 Search the web| http://www.google.com` for normal size fonts, or if you want to go bigger then:\r\n\r\n`5 Netflix|http://www.netflix.com`\r\n\r\nYou can use `1 symbols|http://www.alt-codes.net` too, like this one:`3 ♫` or `2 ╬`\r\n\r\nYou are limited to the size of the box, so if you overflow, what you write cannot be seen:\r\n\r\n<><><><><><><><><><><><><><><><><><><><><><><><><><><><><>\r\n`2 <><><><><><><><><><><><><><><><><><><><><><><><><><><><><>`\r\n`3 <><><><><><><><><><><><><><><><><><><><><><><><><><><><><>`\r\nand you should not be able to see this line here \r\n\r\n\r\n",
			published:true, location: 'New York')
		Post.create!(content: 'normal text', published: true, location: 'Oz')
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