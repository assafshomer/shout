require 'spec_helper'
include ViewsHelper

describe "PostPages" do
	subject { page }

	describe "Home" do
		let!(:button) { submit_button_title }
		before { visit root_path }
		it { should have_title 'Speak UP' }
		it { should have_content('footer') }
		it { should have_content('header') }
		it { should have_selector('textarea#post_content') }
		it { should have_xpath("//textarea[@placeholder='Think inside the box...']") }
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

	describe "index" do
		let!(:signature) { "Test Post - #{rand(1..100000000)}" }
		let!(:post) { (Post.new(content: signature)).save  }
			
		before { visit posts_path }
		it { should have_title 'index' }
		it { should have_selector('td', text: signature) }
	end

end
