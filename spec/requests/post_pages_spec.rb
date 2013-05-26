require 'spec_helper'

describe "PostPages" do
	subject { page }
	before { visit root_path }
	it { should have_selector('textarea#shout_content') }
end
