module TestHelper

include ActionView::Helpers::DateHelper
include ViewsHelper
include MarkupHelper
include PostsHelper


	def random_array(range, size)
		(1..range).to_a.sample size
	end
	
  shared_examples_for "all pages" do 
		it { should have_title app_title+" - " + page_title }
		it { should have_content('footer') }	
		it { should have_link home_title }
		it { should have_link tile_title }			
  end	

end