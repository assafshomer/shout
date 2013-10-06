require 'spec_helper'
include TestHelper

describe "Search Posts" do
	subject { page }
		let!(:post_array) { [] }
	before(:each) do
		5.times {post_array << FactoryGirl.create(:post, content: Faker::Lorem.sentence) }	
		post_array << FactoryGirl.create(:post,
		 content: "Hey hey my my, Rock & Roll may never die")					
		post_array << FactoryGirl.create(:post,
		 content: "But his laughing lady's loving ain't the kind he can keep")		
		post_array << FactoryGirl.create(:post,
		 content: "my my hey hey rocknroll is here to stay")
		post_array << FactoryGirl.create(:post,
		 content: "there's more to the picture than meets the eye, hey hey my my")	  		
	end

	describe "on Index" do
		before { visit posts_path }
		it "should display each of the posts" do
			post_array.sort {|x,y| x.created_at<=>y.created_at}.reverse[0..(tile_size-1)].each do |post|
				page.should have_selector("div##{post.id}", text: post.content) 		
				page.should have_selector('span.timestamp', text: time_ago_in_words(post.created_at)) 
			end
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
					page.should_not have_selector("div##{post.id}", text: post.content) 		
					page.should_not have_selector('span.timestamp', text: time_ago_in_words(post.created_at)) 
				end
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
				post_array.sort {|x,y| x.created_at<=>y.created_at}.reverse[0..(tile_size-1)].each do |post|
					page.should have_selector("div##{post.id}", text: post.content) 		
					page.should have_selector('span.timestamp', text: time_ago_in_words(post.created_at)) 
				end
			end
		end
		describe "search should filter correctly" do
			before do
				visit root_path 
				fill_in 'inputbox', with: 'supercalifragilisticexpialidocious'[0..29]
				click_button submit_button_title
				visit posts_path
				fill_in 'search', with: 'supercalifragilisticexpialidocious'[0..29]
				click_button 'Search'			
			end			
			it { should have_selector('div.smalloutput', text: 'supercalifragilisticexpialidocious'[0..29]) }		
		end
	end

end
