module ViewsHelper
	def preview_button_title
		# app_title
		"click to preview"
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

	def shapes_title
		'shapes'
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
		"You are limited to within the box"
	end

	def search_tile_count
		if Rails.env == 'test'
			5
		else
			15 
		end		
	end

	def ascii_array
		if Rails.env == 'test'
			array = (9820..9830).to_a
		else
			array = clean_blanks((256..13038).to_a)
		end

	end


# def findrange(string)
# 	result= string.scan(/\d{4}=>/).each do |s|
# 		s.sub!(/=>/,"")    
# 	end
# 	return result.min+".."+result.max
# end

private
	def clean_blanks(array)
		array.reject! {|x| [1770,1773,1968,2304].include? x}
		array.reject! {|x| (767..879).include? x}
		array.reject! {|x| (1155..1159).include? x}
		array.reject! {|x| (1318..1328).include? x}
		array.reject! {|x| (1416..1487).include? x}
		array.reject! {|x| (1515..1566).include? x}
		array.reject! {|x| (1611..1631).include? x}
		array.reject! {|x| (1750..1757).include? x}
		array.reject! {|x| (1759..1764).include? x}
		array.reject! {|x| (1767..1768).include? x}		
		array.reject! {|x| (1837..1919).include? x}
		array.reject! {|x| (1969..1983).include? x}
		array.reject! {|x| (2024..2039).include? x}
		array.reject! {|x| (2043..2303).include? x}
		array.reject! {|x| (2642..2648).include? x}
		array.reject! {|x| (2769..2783).include? x}
		array.reject! {|x| (3676..3712).include? x}
		array.reject! {|x| (3802..4255).include? x}
		array.reject! {|x| (4294..4303).include? x}
		array.reject! {|x| (4349..4607).include? x}
		array.reject! {|x| (5873..5919).include? x}
		array.reject! {|x| (5943..6015).include? x}
		array.reject! {|x| (6138..6319).include? x}
		array.reject! {|x| (6390..6479).include? x}
		array.reject! {|x| (6517..6623).include? x}
		array.reject! {|x| (6684..7423).include? x}
		array.reject! {|x| (7626..7679).include? x}
		array.reject! {|x| (8191..8211).include? x}
		array.reject! {|x| (8228..8239).include? x}
		array.reject! {|x| (9168..9177).include? x}
		array.reject! {|x| (9193..9215).include? x}
		array.reject! {|x| (2586..2592).include? x}
		array.reject! {|x| (9256..9279).include? x}
		array.reject! {|x| (9291..9311).include? x}
		array.reject! {|x| (9917..9919).include? x}
		array.reject! {|x| (9924..9953).include? x}
		array.reject! {|x| (9955..9984).include? x}
		array.reject! {|x| (10629..10701).include? x}
		array.reject! {|x| (10710..10730).include? x}
		array.reject! {|x| (10732..10745).include? x}
		array.reject! {|x| (10748..10751).include? x}
		array.reject! {|x| (10782..10876).include? x}
		array.reject! {|x| (10913..10925).include? x}
		array.reject! {|x| (10939..10954).include? x}
		array.reject! {|x| (10957..11007).include? x}
		array.reject! {|x| (11056..11087).include? x}
		array.reject! {|x| (11093..11263).include? x}
		array.reject! {|x| (11442..11455).include? x}
		array.reject! {|x| (11458..11463).include? x}
		array.reject! {|x| (11468..11491).include? x}
		array.reject! {|x| (11499..11516).include? x}
		array.reject! {|x| (11558..11567).include? x}
		array.reject! {|x| (11622..11743).include? x}
		array.reject! {|x| (11776..11809).include? x}
		array.reject! {|x| (11814..12031).include? x}
		array.reject! {|x| (12245..12287).include? x}
		array.reject! {|x| (12330..12338).include? x}
		array.reject! {|x| (12687..12783).include? x}
		array.reject! {|x| (12851..12880).include? x}
		array.reject! {|x| (12928..12937).include? x}
		array.reject! {|x| (12949..12957).include? x}
		array.reject! {|x| (12969..12976).include? x}
		array.reject! {|x| (12992..13000).include? x}			
	end
	

end