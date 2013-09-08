require 'spec_helper'
include TestHelper

describe "PostPages" do
	subject { page }
  shared_examples_for "all pages" do 
		it { should have_title app_title }
		it { should have_content('footer') }	
		it { should have_link home_title }
		it { should have_link tile_title }			
  end

	describe "Home" do
		let!(:button) { submit_button_title }
		before do
			# Post.delete_all
			visit root_path
		end			
		it_should_behave_like 'all pages'
		it { should have_selector('textarea#post_content') }
		# it { should have_xpath("//textarea[@placeholder=\'#{post_place_holder}\']") }
		it { should have_selector('input#shoutup_button') }
		it { should have_xpath("//input[@value=\'#{button}\']") }		
		describe "validations" do
			describe "clicking the post button with an empty post should raise an error" do
				before { click_button button }
				it { should have_selector('div.alert.alert-error', text: '2 errors') }
			end
			describe "clicking the post button with a single character post should raise an error" do
				before do
				  fill_in 'post_content', with: 'x'
				  click_button button
				end
				it { should have_selector('div.alert.alert-error', text: '1 error') }
			end
			describe "posting OK should not raise any errors and should flash" do
				before do
				  fill_in 'post_content', with: 'OK'
				  click_button button
				end
				it { should_not have_selector('div.alert.alert-error', text: 'error') }
				it { should have_selector('div.alert.alert-success') }
			end
		end
		describe "persistance" do
			before { fill_in 'post_content', with: 'foobar' }
			it "should save the post to the db" do
				expect {click_button button}.to change(Post, :count).by(1)
			end
		end 
	end

	describe "show" do
		subject { page }
		let!(:p1) {FactoryGirl.create(:post)}
		before(:each) do		  
		  visit post_path p1.id
		end
		it_should_behave_like 'all pages'			
		it { should have_content(p1.content) }	
	end

	describe "index" do		
		before do
			Post.delete_all
			6.times do
				FactoryGirl.create(:post)
			end			
			visit posts_path
		end
		it_should_behave_like 'all pages'
		it { should_not have_selector('textarea#post_content') }		
		it { should_not have_selector('input#shoutup_button') }		
		it { should have_selector('div.pagination') } 

	end

end