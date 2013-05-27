require 'spec_helper'

describe "PostPages" do
	subject { page }
	before { visit root_path }
	it { should have_selector('textarea#post_content') }
	it { should have_xpath("//textarea[@placeholder='Think inside the box...']") }
	it { should have_selector('input#shoutup_button') }
	it { should have_xpath("//input[@value='ShoutUp']") }
end
