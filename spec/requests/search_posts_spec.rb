require 'spec_helper'
include TestHelper

describe "Search Posts" do
	subject { page }
		let!(:post_array) { [] }
		let!(:bbpub) { FactoryGirl.create(:post, content: "Walter published", published: true) }
		let!(:bbpre) { FactoryGirl.create(:post, content: "Walter preview") }
	before(:each) do
		5.times {post_array << FactoryGirl.create(:post, content: Faker::Lorem.sentence, published: true) }	
		post_array << FactoryGirl.create(:post, published: true,
		 content: "Hey hey my my, Rock & Roll may never die")					
		post_array << FactoryGirl.create(:post, published: true,
		 content: "But his laughing lady's loving ain't the kind he can keep")		
		post_array << FactoryGirl.create(:post, published: true,
		 content: "my my hey hey rocknroll is here to stay")
		post_array << FactoryGirl.create(:post, published: true,
		 content: "there's more to the picture than meets the eye, hey hey my my")
	end

	describe "on Index" do
		before { visit posts_path }
		it "should display each of the posts" do
			post_array.sort {|x,y| x.created_at<=>y.created_at}.reverse[0..(tile_count-1)].each do |post|
				page.should have_selector("div##{post.id}", text: /#{pulverize(post.content,'\W')}/) 		
				# page.should have_selector('span.timestamp', text: time_ago_in_words(post.created_at)) 
			end
		end
		it "should not display the preview" do
			page.should_not have_selector('div.smalloutput', text: /#{pulverize(bbpre.content,'\W')}/)
		end
		it "should not show the 'of which ... matching' message" do
			page.should_not have_selector('div#counter', text: "of which")
		end
		describe "with search term that cannot be found" do
			before do 
				fill_in 'search', with: 'supercalifragilisticexpialidocious'
				click_button 'Search'
			end			
			it { should have_xpath("//input[@value=\'Search\']") }
			it { should have_xpath("//input[@value=\'Clear\']") }
			it { should  have_selector('input#search') }
			it "should display none of the posts" do
				post_array.each do |post|
					page.should_not have_selector("div##{post.id}", text:/#{pulverize(post.content,'\W')}/) 		
				end
			end
		end
		describe "with search that is only in preview but not published" do
			before do 
				fill_in 'search', with: 'Walter'
				click_button 'Search'
			end			
			it { should have_xpath("//input[@value=\'Search\']") }
			it { should have_xpath("//input[@value=\'Clear\']") }
			it { should  have_selector('input#search') }
			it "should display only the published search result" do
				page.should_not have_selector("div##{bbpre.id}", text: /#{pulverize(bbpre.content,'\W')}/) 		
				page.should have_selector("div##{bbpub.id}", text: /#{pulverize(bbpub.content,'\W')}/) 		
			end
		end		
		describe "clearing" do
			before do 
				fill_in 'search', with: 'supercalifragilisticexpialidocious'
				click_button 'Search'
				click_button 'Clear'
				visit posts_path
			end			
			it "should display all posts" do
				post_array.sort {|x,y| x.created_at<=>y.created_at}.reverse[0..(tile_count-1)].each do |post|
					page.should have_selector("div##{post.id}", /#{pulverize(post.content,'\W')}/) 
					# page.should have_selector('span.timestamp', text: time_ago_in_words(post.created_at)) 
				end
			end
		end
		describe "search should filter correctly" do
			let!(:s) { 'supercalifragilisticexpialidocious'[0..29] }
			before do
				visit new_post_path 
				fill_in 'inputbox', with: s
				click_button preview_button_title
				click_button publish_button_title
				visit posts_path
				fill_in 'search', with: s
				click_button 'Search'			
			end			
			it { should have_selector("div##{Post.first.id}", text: /#{pulverize(s,'\W')}/) }
		end

		describe "search in location" do
			before do
				visit signin_path
				fill_in 'location', 	with: 'Vietnam'
				click_button 'location_button'
				visit new_post_path
				fill_in 'inputbox', 	with: 'Norm from Saigon'
				click_button preview_button_title
				click_button publish_button_title
				visit posts_path
				fill_in 'search', 		with: 'Viet'
				click_button 'Search'			  
			end
			it { should have_selector("div##{Post.first.id}", text: /#{pulverize('Norm from Saigon','\W')}/) }
		end		
	end

	# describe "local stream" do
	# 	before do
	# 		visit signin_path
	# 		fill_in 'location', 	with: 'Vietnam'
	# 		click_button signin_button_title
	# 		visit new_post_path
	# 		fill_in 'inputbox', 	with: 'Norm from Saigon'
	# 		click_button preview_button_title
	# 		click_button publish_button_title
	# 		visit posts_path
	# 	end		
	# end

end
