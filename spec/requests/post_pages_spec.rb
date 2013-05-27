require 'spec_helper'

describe "PostPages" do
	subject { page }
	before { visit root_path }
	it { should have_selector('textarea#post_content') }
	it { should have_xpath("//textarea[@placeholder='Think inside the box...']") }
	it { should have_selector('input#shoutup_button') }
	it { should have_xpath("//input[@value='ShoutUp']") }
	describe "clicking the post button with an empty post should raise an error" do
		before { click_button 'ShoutUp' }
		it { should have_selector('div.alert.alert-error', text: 'error') }
	end
end
