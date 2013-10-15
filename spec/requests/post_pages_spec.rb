require 'spec_helper'
include TestHelper

	two_lines="of.
After"
	line_break="before \r\n after"

describe "PostPages" do
	subject { page }
  shared_examples_for "all pages" do 
		it { should have_title app_title }
		it { should have_content('footer') }	
		it { should have_link home_title }
		it { should have_link tile_title }			
  end

	describe "Home" do
		
		before do
			# Post.delete_all # I should fix the suite to work also when the test db is empty
			visit root_path
		end			
		it_should_behave_like 'all pages'
		it { should have_selector('textarea#inputbox') }
		# it { should have_xpath("//textarea[@placeholder=\'#{post_place_holder}\']") }
		it { should have_selector('input#preview_button') }
		it { should have_xpath("//input[@value=\'#{preview_button_title}\']") }		
		describe "validations" do
			describe "clicking the post button with an empty post should raise an error" do
				before { click_button preview_button_title }
				it { should have_selector('div.alert.alert-error', text: '2 errors') }
			end
			describe "clicking the post button with a single character post should raise an error" do
				before do
				  fill_in 'inputbox', with: 'x'
				  click_button preview_button_title
				end
				it { should have_selector('div.alert.alert-error', text: '1 error') }
			end
			describe "posting OK should not raise any errors and should flash" do
				before do
				  fill_in 'inputbox', with: 'OK'
				  click_button preview_button_title
				end
				it { should_not have_selector('div.alert.alert-error', text: 'error') }
				it { should have_selector('div.alert.alert-success') }
			end
		end
		describe "persistance" do
			before { fill_in 'inputbox', with: 'foobar' }
			it "should save the post to the db" do
				expect {click_button preview_button_title}.to change(Post, :count).by(1)
			end
		end 
	end

	describe "show" do
		describe "random post" do
			let!(:p1) {FactoryGirl.create(:post)}
			before(:each) do		  
			  visit post_path p1.id	
			end
			it_should_behave_like 'all pages'			
			it { should have_selector('div.bigoutput', text: /#{pulverize(p1.content,'\W')}/) }				
		end
		describe "post with newline" do
			let!(:p1) { FactoryGirl.create(:post, content: two_lines) }
			before { visit post_path p1.id }
			it { should have_selector('div.bigoutput',
			 text: /#{pulverize('of.','\W')}.*#{pulverize('After','\W')}/)}
			it { should_not have_selector('div.bigoutput',
			 text: /#{pulverize('of.','\W')}#{pulverize('After','\W')}/)}
		end
		describe "post with line breaks" do
			let!(:p1) { FactoryGirl.create(:post, content: line_break) }
			before { visit post_path p1.id }
			it { should have_selector('div.bigoutput',
			 text: /#{pulverize('before','\W')}.*#{pulverize('after','\W')}/)}
			it { should_not have_selector('div.bigoutput',
			 text: /#{pulverize('before','\W')}#{pulverize('after','\W')}/)}			
		end		
		describe "posts with active links" do
			let!(:link) { "`1 google|http://www.google.com`" }
			before do
			  visit root_path
			  fill_in 'inputbox', with: link
			  click_button preview_button_title
			  visit post_path(Post.all.ids.max)
			end
			it { should have_link('g​o​o​g​l​e​') } #note that this includes ZWSPs
			it { should have_xpath("//a[@href='http://www.google.com']") }			
			it { should_not have_xpath("//a[@href='http://www.yahoo.com']") }						
			it { should_not have_link('', href: post_path("#{Post.all.ids.max}")) }	
		end
	end

	describe "index" do		
		before do
			FactoryGirl.create(:post, content: "a"+"\r\n"*20+"...")
			FactoryGirl.create(:post, content: "line 1\r\nline 2\r\nline 3\r\n4\r\n5\r\n6\r\n7\r\n8\r\n9\r\n10\r\n11\r\n1...")
			tile_size.times do
				FactoryGirl.create(:post)
			end
			visit posts_path
		end
		it_should_behave_like 'all pages'
		it { should_not have_selector('textarea#post_content') }		
		it { should_not have_selector('input#preview_button') }		
		it { should have_selector('div.pagination') } 
		describe "linking to show" do
			describe "simple linking" do
				let!(:text) { "test simple link" }
				before do
				  visit root_path
				  fill_in 'inputbox', with: text
				  click_button preview_button_title
				  visit posts_path			  
				end
				it { should have_selector("div.smalloutput##{Post.all.ids.max}",
				 text: /#{pulverize(text,'\W')}/) }
				it { should have_link('', href: post_path("#{Post.all.ids.max}")) }	
				describe "clicking the link to the show template should get you there" do
					before { click_link "tile_#{Post.all.ids.max}" }
					specify {current_path.should == post_path(Post.all.ids.max) }			
				end
			end
			describe "link with url" do
				let!(:link) { "`1 google|http://www.google.com`" }
				before do
				  visit root_path
				  fill_in 'inputbox', with: link
				  click_button preview_button_title
				  visit posts_path
				  # save_and_open_page			  
				end
				it { should have_selector("div.smalloutput##{Post.all.ids.max}",
				 text: /#{pulverize("google",'\W')}/) }
				it { should have_link('', href: post_path("#{Post.all.ids.max}")) }	
				#testing that we don't get the link inside link bug
				it { should have_link('g​o​o​g​l​e​') } #note that this includes ZWSPs
				it { should_not have_xpath("//a[@href='http://www.google.com']") }
				describe "clicking the link to the show template should get you there" do
					before {  click_link 'g​o​o​g​l​e​' }
					specify {current_path.should == post_path(Post.all.ids.max) }			
				end											
			end
		end
	end
end