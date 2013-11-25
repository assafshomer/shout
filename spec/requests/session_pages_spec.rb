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

	describe "filling in a location" do
		before do
		  fill_in "location",             with: "foobar"  
		  click_button signin_button_title
		  visit root_path
		end
		it { should have_title home_title }
		it { should have_link(wrap_location('foobar'), href: signin_path) }	
		# it { should have_link('#location', text: wrap_location('foobar')) }
	end

	describe "filling in a location and trimming" do
		before do
		  fill_in "location",             with: "   a  b   "  
		  click_button signin_button_title
		  visit root_path
		end
		it { should have_title home_title }
		it { should have_link('(a b)', href: signin_path) }	
	end	

	describe "filling in a blank location" do
		before do
		  fill_in "location",             with: ''  
		  click_button signin_button_title
		  visit root_path
		end
		it { should have_title home_title }
		it { should_not have_link(wrap_location(''), href: signin_path) }	
	end	
end
