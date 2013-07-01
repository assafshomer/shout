require 'spec_helper'
include TestHelper

describe "Search Posts" do
	subject { page }
		let!(:post_array) { [] }
	before(:each) do
		20.times {post_array << FactoryGirl.create(:post, content: Faker::Lorem.sentence) }	
		post_array << FactoryGirl.create(:post, content: "Hey hey my my, Rock & Roll may never die")					
		post_array << FactoryGirl.create(:post, content: "But his laughing lady's loving ain't the kind he can keep")		
		post_array << FactoryGirl.create(:post, content: "my my hey hey rocknroll is here to stay")
		post_array << FactoryGirl.create(:post, content: "there's more to the picture than meets the eye, hey hey my my")	  
		visit root_path
	end
	it "should display each of the posts" do
		post_array.each do |post|
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
	end		
end
