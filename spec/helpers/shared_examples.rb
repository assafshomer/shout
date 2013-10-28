shared_examples_for "all pages" do 
	it { should have_title app_title+" - " + page_title }
	it { should have_content('footer') }	
	it { should have_link home_title }
	it { should have_link tile_title }			
end	