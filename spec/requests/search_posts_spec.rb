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

	describe "on HomePage" do
		before { visit root_path }
		it "should display each of the posts" do
			post_array.sort {|x,y| x.created_at<=>y.created_at}.reverse[0..4].each do |post|
				page.should have_selector("div##{post.id}", text: post.content) 		
				page.should have_selector('span.timestamp', text: time_ago_in_words(post.created_at)) 
			end
		end
		describe "search bar should still be there" do
			before do 
				fill_in 'search', with: 'supercalifragilisticexpialidocious'
				click_button 'Search'				
			end			
			it { should have_xpath("//input[@value=\'Search\']") }
			it { should have_xpath("//input[@value=\'Clear\']") }
			it { should  have_selector('input#search') }
			it "should display none of the posts" do
				post_array.sort {|x,y| x.created_at<=>y.created_at}.reverse[0..4].each do |post|
					page.should_not have_selector("div##{post.id}", text: post.content) 		
					page.should_not have_selector('span.timestamp', text: time_ago_in_words(post.created_at)) 
				end
			end
			it "should show a count of zero" do
				page.should have_selector('div#counter', text: "#{Post.count} posts")
				page.should have_selector('div#counter', text: "0 matches")
				page.should_not have_content 'no posts at this time'
			end
		end
		describe "clearing" do
			before do 
				fill_in 'search', with: 'supercalifragilisticexpialidocious'
				click_button 'Search'
				click_button 'Clear'
				visit root_path				
			end			
			it "should display all posts" do
				post_array.sort {|x,y| x.created_at<=>y.created_at}.reverse[0..4].each do |post|
					page.should have_selector("div##{post.id}", text: post.content) 							
					page.should have_selector('span.timestamp', text: time_ago_in_words(post.created_at)) 
				end
			end
			it "should show a no search message in the counter" do
				page.should have_selector('div#counter', text: "#{Post.count} posts")
				page.should_not have_selector('div#counter', text: 'matches')
			end			
		end
		describe "search should filter correctly on a word that does not exist" do
			before do 
				fill_in 'post_content', with: 'supercalifragilisticexpialidocious'[0..29]
				click_button submit_button_title
				fill_in 'search', with: 'supercalifragilisticexpialidocious'[0..29]
				click_button 'Search'			
			end			
			it { should have_selector('span.content', text: 'supercalifragilisticexpialidocious'[0..29]) }		
		end
		describe "search on 'my my' should" do
			before do 
				fill_in 'search', with: 'my my'
				click_button 'Search'			
			end
			it "display just posts with 'my my', and display their count correctly" do
				post_array.select {|x| x.content =~ /my my/}.each do |post|
					page.should have_selector("div##{post.id}", text: post.content)					 							
				end
			end	
			it "display the correct post count" do				
				page.should have_selector("div#counter", text: "3 matches")					 											
			end														
		end	

	end

	describe "on Index" do
		before { visit posts_path }
		it "should display each of the posts" do
			post_array.sort {|x,y| x.created_at<=>y.created_at}.reverse[0..4].each do |post|
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
				post_array.sort {|x,y| x.created_at<=>y.created_at}.reverse[0..4].each do |post|
					page.should have_selector("div##{post.id}", text: post.content) 		
					page.should have_selector('span.timestamp', text: time_ago_in_words(post.created_at)) 
				end
			end
		end
		describe "search should filter correctly" do
			before do
				visit root_path 
				fill_in 'post_content', with: 'supercalifragilisticexpialidocious'[0..29]
				click_button submit_button_title
				visit posts_path
				fill_in 'search', with: 'supercalifragilisticexpialidocious'[0..29]
				click_button 'Search'			
			end			
			it { should have_selector('span.content', text: 'supercalifragilisticexpialidocious'[0..29]) }		
		end
	end

end
