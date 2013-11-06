require 'spec_helper'
require 'shared_examples'
include TestHelper

describe "signup" do
	subject { page }
	before { visit signin_path }
	it { should have_title signin_title }
	it { should have_selector('input#location') }
	it { should have_button signin_button_title }
	it { should have_xpath("//input[@placeholder=\'#{location_placeholder}\']") }
end
