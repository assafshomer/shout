require 'spec_helper'

describe "PostPages" do
	subject { page }
	before { visit root_path }
	it { should have_selector('textarea#post_content') }
	it { should have_xpath("//textarea[@placeholder='Think inside the box...']") }
	it { should have_selector('input#shoutup_button') }
	it { should have_xpath("//input[@value='ShoutUp']") }
	describe "validations" do
		describe "clicking the post button with an empty post should raise an error" do
			before { click_button 'ShoutUp' }
			it { should have_selector('div.alert.alert-error', text: '2 errors') }
		end
		describe "clicking the post button with a single character post should raise an error" do
			before do
			  fill_in 'post_content', with: 'x'
			  click_button 'ShoutUp'
			end
			it { should have_selector('div.alert.alert-error', text: '1 error') }
		end
		describe "posting OK should not raise any errors" do
			before do
			  fill_in 'post_content', with: 'OK'
			  click_button 'ShoutUp'
			end
			it { should_not have_selector('div.alert.alert-error', text: 'error') }
		end		
	end
	describe "persistance" do
		before { fill_in 'post_content', with: 'foobar' }
		it "should save the post to the db" do
			expect {click_button 'ShoutUp'}.to change(Post, :count).by(1)
		end
	end
end
