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

	describe "null location should show 'set your location'" do
		before { visit root_path }
		it { should have_link(wrap_location(signin_button_title), href: signin_path) }	
		before { visit help_path }
		it { should have_link(wrap_location(signin_button_title), href: signin_path) }	
		before { visit shapes_path }
		it { should have_link(wrap_location(signin_button_title), href: signin_path) }	
		before { visit about_path }
		it { should have_link(wrap_location(signin_button_title), href: signin_path) }	
		before { visit contact_path }
		it { should have_link(wrap_location(signin_button_title), href: signin_path) }	
	end			

	describe "filling in a location" do
		describe "well formed location" do
			before do
			  fill_in "location",             with: "foobar"  
			  click_button signin_button_title
			  visit root_path
			end
			it { should have_title home_title }
			it { should have_link(wrap_location('foobar'), href: signin_path) }	
			# it { should have_link('#location', text: wrap_location('foobar')) }
		end

		describe "trimming" do
			before do
			  fill_in "location",             with: "   a  b   "  
			  click_button signin_button_title
			  visit root_path
			end
			it { should have_title home_title }
			it { should have_link('(a b)', href: signin_path) }	
			it { should_not have_link('foobar', href: signin_path) }	
		end	

		describe "blank location" do
			before do
			  fill_in "location",             with: ''  
			  click_button signin_button_title
			  visit root_path
			end
			it { should have_title home_title }
			it { should have_link(wrap_location(signin_button_title), href: signin_path) }
		end		
	end


	describe "persistance in Post model" do
		describe "preview" do
			describe "well formed location" do
				let!(:loc) { 'Tel-Aviv' }
				before do
				  fill_in "location",             with: loc
				  click_button signin_button_title
				  visit new_post_path
				  fill_in 'inputbox', with: 'blah blah'
					click_button preview_button_title
				end
				specify {Post.first.location.should == loc}
				specify {Post.first.location.should_not == 'foobar'}
			end			

			describe "well formed location" do
				let!(:loc) { '' }
				before do
				  fill_in "location",             with: loc
				  click_button signin_button_title
				  visit new_post_path
				  fill_in 'inputbox', with: 'blah blah'
					click_button preview_button_title
				end
				specify {Post.first.location.should be_nil}
			end				
		end
		describe "publish" do
			describe "well formed location" do
				let!(:loc) { 'Tel-Aviv' }
				before do
				  fill_in "location",             with: loc
				  click_button signin_button_title
				  visit new_post_path
				  fill_in 'inputbox', with: 'blah blah'
					click_button preview_button_title
					click_button publish_button_title
				end
				specify {Post.first.location.should == loc}
				specify {Post.first.location.should_not == 'foobar'}
			end			

			describe "well formed location" do
				let!(:loc) { '' }
				before do
				  fill_in "location",             with: loc
				  click_button signin_button_title
				  visit new_post_path
				  fill_in 'inputbox', with: 'blah blah'
					click_button preview_button_title
					click_button publish_button_title
				end
				specify {Post.first.location.should be_nil}
			end				
		end
		describe "change location between preview and publish" do
			describe "well formed location" do
				let!(:loc) { 'Tel-Aviv' }
				before do
				  fill_in "location",             with: ''
				  click_button signin_button_title
				  visit new_post_path
				  fill_in 'inputbox', with: 'boohaha'
					click_button preview_button_title
					click_link 'location'
					fill_in "location",             with: loc
				  click_button signin_button_title
				  visit edit_post_path(Post.first)
				  fill_in 'inputbox', with: 'moohaha'
					click_button publish_button_title				  
				end
				specify {Post.first.location.should == loc}
			end						
		end					
	end


end
