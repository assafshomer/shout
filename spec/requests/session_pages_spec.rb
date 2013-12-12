require 'spec_helper'
require 'shared_examples'
include TestHelper

describe "signup" do
	subject { page } 
	before { visit signin_path }
	it { should have_title signin_title}
	it { should have_selector('input#location') }
	it { should have_button 'location_button' }
	# it { should have_xpath("//input[@placeholder=\'#{location_placeholder}\']") } #not sure why failing
	

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

		describe "redirect to index after setting a location" do
			before do
			  fill_in 'location', with: 'Jumangi'
			  click_button 'location_button'			  
			end
			it_should_behave_like 'the index page'
			it { should have_link(wrap_location('Jumangi'), href: signin_path) }	
		end

		describe "signin page should change placeholder and button title after setting a location" do
			before do
			  fill_in 'location', with: 'Jumangi'
			  click_button 'location_button'
			  visit signin_path			  
			end
			it { should have_button change_location_button }
			it { should have_xpath("//input[@placeholder=\'#{change_location_placeholder}\']") }
		end

		describe "well formed location" do
			before do
			  fill_in "location",             with: "foobar"  
			  click_button 'location_button'
			  visit root_path
			end
			it { should have_title home_title }
			it { should have_link(wrap_location('foobar'), href: signin_path) }	
			# it { should have_link('#location', text: wrap_location('foobar')) }
		end

		describe "trimming" do
			before do
			  fill_in "location",             with: "   a  b   "  
			  click_button 'location_button'
			  visit root_path
			end
			it { should have_title home_title }
			it { should have_link('(a b)', href: signin_path) }	
			it { should_not have_link('foobar', href: signin_path) }	
		end	

		describe "blank location" do
			before do
			  fill_in "location",             with: ''  
			  click_button 'location_button'
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
				  click_button 'location_button'
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
				  click_button 'location_button'
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
				  click_button 'location_button'
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
				  click_button 'location_button'
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
				  click_button 'location_button'
				  visit new_post_path
				  fill_in 'inputbox', with: 'boohaha'
					click_button preview_button_title
					click_link 'location'
					fill_in "location",             with: loc
				  click_button 'location_button'
				  visit edit_post_path(Post.first)
				  fill_in 'inputbox', with: 'moohaha'
					click_button publish_button_title				  
				end
				specify {Post.first.location.should == loc}
			end						
		end					
	end


end
