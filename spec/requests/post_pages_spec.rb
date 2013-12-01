require 'spec_helper'
require 'shared_examples'
include TestHelper
include ViewsHelper

	two_lines="of.
After"
	line_break="before \r\n after"

describe "PostPages" do
	subject { page }


	describe "new" do
		let!(:page_title) { new_title }		
		before do
			visit new_post_path
		end			
		it { should have_selector('textarea#inputbox', text: "") }
		it { should_not have_selector('div.bigoutput') }		
		it { should have_xpath("//textarea[@placeholder=\'#{post_place_holder}\']") }
		it { should have_button preview_button_title}
		it { should have_selector('input#preview_button') }
		it { should have_xpath("//input[@value=\'#{preview_button_title}\']") }	
		it { should_not have_xpath("//input[@value=\'#{preview_button_title}\'][@disabled='disabled']") }		
		it { should_not have_button publish_button_title}
		it { should_not have_selector('input#publish_button') }
		it { should_not have_xpath("//input[@value=\'#{publish_button_title}\']") }
		# it { should have_xpath("//input[@value=\'#{publish_button_title}\'][@disabled='disabled']") }		


		describe "preview_button" do
			shared_examples_for "an invalid post" do
				it { should have_selector('div.alert.alert-error', text: 'too short') }
				it { should have_button preview_button_title}
				it { should_not have_selector('div.bigoutput') }		
				it { should_not have_button publish_button_title }
				it { should_not have_selector('div.alert.alert-success') }
			end
			describe "clicking the preview button with an empty post should raise an error and not post" do
				before { click_button preview_button_title }
				it_should_behave_like 'all pages'
				it_should_behave_like 'a page with sidebar'
				it_should_behave_like 'an invalid post'
			end
			describe "clicking the preview button with a single character post should raise an error and not post" do
				before do
				  fill_in 'inputbox', with: 'x'
				  click_button preview_button_title
				end
				it_should_behave_like 'all pages'
				it_should_behave_like 'a page with sidebar'
				it_should_behave_like 'an invalid post'
			end
			describe "preveiwing OK should not raise errors, flash, preview the content and redirect to the edit page" do
				before do
				  fill_in 'inputbox', with: 'OK'
				  click_button preview_button_title
				end
				it_should_behave_like 'all pages'
				it_should_behave_like 'a page with sidebar'
				it { should_not have_selector('div.alert.alert-error', text: 'error') }
				it { should_not have_selector('div.alert.alert-success') }
				it { should have_selector('textarea#inputbox', text: "OK") }
				it { should have_selector('div.bigoutput', text: /#{pulverize('OK','\W')}/) }
				specify {current_path.should == edit_post_path(Post.ids.max)}
				it { should have_button preview_button_title}
				it { should have_button publish_button_title}	
			end				
		end

		describe "publish button" do
			describe "publishing OK should not raise any errors, flash and return to the new template" do
				before do
				  fill_in 'inputbox', with: 'OK'
				  click_button preview_button_title
				  click_button publish_button_title
				end
				it { should_not have_selector('div.alert.alert-error', text: 'error') }
				it { should have_selector('div.alert.alert-success') }
				it { should_not have_selector('textarea#inputbox', text: "OK") }
				it { should_not have_selector('div.bigoutput', text: /#{pulverize('OK','\W')}/) }	
				it { should have_xpath("//textarea[@placeholder=\'#{post_place_holder}\']") }	
				it { should have_button preview_button_title}
				it { should_not have_button publish_button_title }							
				specify {current_path.should == new_post_path}
			end				
		end

		describe "persistance" do
			before { fill_in 'inputbox', with: 'foobar' }
			it "should save the post to the db" do
				expect {click_button preview_button_title}.to change(Post.previewed, :count).by(1)				
			end
			it "previewing should not publish the post" do
				expect {click_button preview_button_title}.not_to change(Post.published, :count)
			end						
			it "publishing should save the post to the db and mark it as published" do
				expect {click_button preview_button_title; click_button publish_button_title}.to change(Post.published, :count).by(1)				
				
			end	
			it "publishing should not change the previews count" do
				expect {click_button preview_button_title; click_button publish_button_title}.not_to change(Post.previewed, :count)
			end						
		end 
	end

	describe "edit" do
		let!(:page_title) { edit_title }		
		before do
			visit new_post_path
			fill_in 'inputbox', with: "blah blah"
			click_button preview_button_title			
		end
		it_should_behave_like 'all pages'
		it_should_behave_like 'a page with sidebar'
		specify {current_path.should == edit_post_path(Post.ids.max)}					
		it { should have_selector('textarea#inputbox', text: "blah blah") }
		it { should have_selector('div.bigoutput', text: /#{pulverize('blah blah','\W')}/) }
		it { should have_selector('input#preview_button') }
		it { should have_selector('input#publish_button') }

		describe "preview_button" do
			describe "clicking the preview button with an empty post should raise an error" do
				before do 
					fill_in 'inputbox', with: ""
					click_button preview_button_title						
				end
				it_should_behave_like 'all pages'
				it_should_behave_like 'a page with sidebar'
				it { should have_selector('div.alert.alert-error', text: 'too short') }
			end
			describe "clicking the preview button with a single character post should raise an error" do
				before do
				  fill_in 'inputbox', with: 'x'
				  click_button preview_button_title
				end
				it_should_behave_like 'all pages'
				it_should_behave_like 'a page with sidebar'				
				it { should have_selector('div.alert.alert-error', text: 'too short') }
			end
			describe "preveiwing OK should not raise errors, flash, preview the content and redirect to the edit page" do
				before do
				  fill_in 'inputbox', with: 'OK'
				  click_button preview_button_title
				end
				it_should_behave_like 'all pages'
				it_should_behave_like 'a page with sidebar'				
				it { should_not have_selector('div.alert.alert-error', text: 'error') }
				it { should_not have_selector('div.alert.alert-success') }
				it { should have_selector('textarea#inputbox', text: "OK") }
				it { should have_selector('div.bigoutput', text: /#{pulverize('OK','\W')}/) }
				specify {current_path.should == edit_post_path(Post.ids.max)}
			end				
		end
		
		describe "publish button" do
			describe "clicking the publish button with an empty post should raise an error" do
				before do 
					fill_in 'inputbox', with: ""
					click_button preview_button_title						
				end
				it_should_behave_like 'all pages'
				it_should_behave_like 'a page with sidebar'				
				it { should have_selector('div.alert.alert-error', text: 'too short') }
			end
			describe "clicking the publish button with a single character post should raise an error" do
				before do
				  fill_in 'inputbox', with: 'x'
				  click_button publish_button_title
				end
				it_should_behave_like 'all pages'
				it_should_behave_like 'a page with sidebar'				
				it { should have_selector('div.alert.alert-error', text: 'too short') }
			end
			describe "publishing OK should not raise any errors, flash and return to the new template" do
				before do
				  fill_in 'inputbox', with: 'OK'
				  click_button publish_button_title
				end
				it_should_behave_like 'all pages'
				it_should_behave_like 'a page with sidebar'				
				it { should_not have_selector('div.alert.alert-error', text: 'error') }
				it { should have_selector('div.alert.alert-success') }
				it { should_not have_selector('textarea#inputbox', text: "OK") }
				it { should_not have_selector('div.bigoutput', text: /#{pulverize('OK','\W')}/) }	
				it { should have_xpath("//textarea[@placeholder=\'#{post_place_holder}\']") }				
				specify {current_path.should == new_post_path}
				it { should have_title full_title(new_title) }
			end				
		end

		describe "persistance on edit page" do
			describe "preview" do
				before { fill_in 'inputbox', with: 'foobar' }
				it "previewing an update should update the post in the db" do
					expect {click_button preview_button_title}.to change{Post.first.content}.from("blah blah").to("foobar")
				end
				it "previewing an update should not change the publication count" do
					expect {click_button preview_button_title}.not_to change(Post.published, :count)
				end	
				it "previewing an update should not change the preview count" do
					expect {click_button preview_button_title}.not_to change(Post.previewed, :count)
				end					
			end
			describe "publish" do
				before { fill_in 'inputbox', with: "bazquuax" }
				it "publishing an update should update the post in the db" do
					expect {click_button publish_button_title}.to change{Post.first.content}.from("blah blah").to("bazquuax")
				end
				it "publishing an update should increase the publication count" do
					expect {click_button publish_button_title}.to change(Post.published, :count).by(1)
				end	
				it "publishing an update should decrease the preview count" do
					expect {click_button publish_button_title}.to change(Post.previewed, :count).by(-1)				
				end					
			end
			# describe "publishing an edit" do
			# 	before do
			# 	  click_button publish_button_title
			# 	  visit edit_post_path(Post.first)
			# 	  fill_in 'inputbox', with: "moohahah"
			# 	  # save_and_open_page
			# 	end
			# 	it "should not change the pubilcation count" do
			# 		expect {click_button publish_button_title}.not_to change(Post.published, :count)
			# 	end
			# 	it "should not change the preview count" do
			# 		expect {click_button publish_button_title}.not_to change(Post.published, :count)
			# 	end				
			# end
			# describe "no publish back to preview, another method" do
			# 	let!(:pub) { FactoryGirl.create(:post, published: true) }
			# 	before do
			# 	  visit edit_post_path(pub)
			# 	  fill_in 'inputbox', with: "moohaha"
			# 	  click_button publish_button_title
			# 	end
			# 	it "should not toggle the published post back to preview" do
			# 		expect {pub.should be_published}
			# 	end
			# end			
		end 
	end

	describe "show" do
		let!(:page_title) { show_title }		
		
		describe "random post" do
			let!(:p1) {FactoryGirl.create(:post)}
			before(:each) do		  
			  visit post_path p1.id	
			end
			it_should_behave_like 'all pages'			
			it { should have_selector('div.bigoutput', text: /#{pulverize(p1.content,'\W')}/) }				
			it { should have_selector('p.metadata', text: /#{metadata(p1)}/) }	
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
			  visit new_post_path
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
		let!(:page_title) { index_title }		
	  shared_examples_for "index page" do 
			it { should_not have_selector('textarea#inputbox') }		
			it { should_not have_selector('input#preview_button') }		
			it { should_not have_selector('input#publish_button') }			
	  end	
		before do
			if tile_count>Post.count
				(tile_count-Post.count+5).times do 
					FactoryGirl.create(:post,content:"xx", published: true)
				end
			end	  	  
	  end	
		describe "with pagination" do
			let!(:preview2) { FactoryGirl.create(:post, content: "moonbuzz") }
			let!(:published2) { FactoryGirl.create(:post,content: "akuna mathata", published: true)  }
			before do
				visit posts_path
			end
			it_should_behave_like 'all pages'
			it_should_behave_like 'index page'		
			it { should_not have_content("no posts at this time") }			
			it { should have_selector('div.pagination') }
			describe "preview" do
				it { should_not have_selector("div##{preview2.id}", text: /#{pulverize(preview2.content,'\W')}/) }	
			end
			describe "tile count should be right" do
				before do
					(tile_count*2).times do
						FactoryGirl.create(:post, published: true, content: "foogazi")
					end 
					fill_in 'search', with: 'foogazi'
					click_button 'Search'
					# save_and_open_page
				end	
				it { should_not have_selector("div##{Post.ids.sort[Post.count-1-search_tile_count]}") }					
			end			
			describe "publish" do
				it { should have_selector("div##{published2.id}", text: /#{pulverize(published2.content,'\W')}/) }					
			end		
		end
		describe "linking to show" do
			describe "simple linking" do
				let!(:text) { "test simple link" }
				before do
				  visit new_post_path
				  fill_in 'inputbox', with: text
				  click_button preview_button_title
				  click_button publish_button_title
				  visit posts_path			  
				end
				it { should have_selector("div##{Post.all.ids.max}",
				 text: /#{pulverize(text,'\W')}/) }
				it { should have_link('', href: post_path("#{Post.all.ids.max}")) }	
			end
			# describe "clicking the link to the show template should get you there" do
			# 	before { click_link "tile_#{Post.all.ids.max}" }
			# 	specify {current_path.should == post_path(Post.all.ids.max) }			
			# end			
			describe "link with url" do
				let!(:link) { "`1 google|http://www.google.com`" }
				before do
				  visit new_post_path
				  fill_in 'inputbox', with: link
				  click_button preview_button_title
				  click_button publish_button_title
				  visit posts_path
				end
				it { should have_selector("div##{Post.all.ids.max}",
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
		describe "no pagination" do
			before { Post.delete_all }
			describe "preview" do
				let!(:preview1) { FactoryGirl.create(:post, content: "foobaz") }
				before {visit posts_path}
				it_should_behave_like 'all pages'
				it_should_behave_like 'index page'				
				it { should_not have_selector('div.pagination') }
				it { should_not have_selector("div##{preview1.id}", text: /#{pulverize(preview1.content,'\W')}/) }	
				it { should have_content("no posts at this time") }				
			end
			describe "publish" do
				let!(:published1) { FactoryGirl.create(:post, content: "buzz quuaax", published: true)  }
				before {visit posts_path}
				it_should_behave_like 'all pages'
				it_should_behave_like 'index page'					
				it { should_not have_selector('div.pagination') }
				it { should have_selector("div##{published1.id}", text: /#{pulverize(published1.content,'\W')}/) }					
				it { should_not have_content("no posts at this time") }				
			end		
		end	
		describe "metadata" do
			describe "for newly published post WITHOUT location" do
				before do
				  visit new_post_path
				  fill_in 'inputbox', with: 'testing metadata'
				  click_button preview_button_title
				  click_button publish_button_title
				  visit posts_path
				end
				it { should have_selector("div##{Post.first.id}", text: /#{pulverize('testing metadata','\W')}/) }					
				it "should show the metadata mousehover on the title" do
					page.should have_xpath("//div[@id=\'#{Post.first.id}\'][@title=\'Posted less than a minute ago in an unknown location\']") 
				end
			end	
			describe "for newly published post WITH location" do
				before do
					visit signin_path
					fill_in 'location', 		with: 'New York'
				  click_button signin_button_title
				  visit new_post_path
				  fill_in 'inputbox', with: 'testing metadata 2'
				  click_button preview_button_title
				  click_button publish_button_title
				  visit posts_path
				end
				it { should have_selector("div##{Post.first.id}", text: /#{pulverize('testing metadata 2','\W')}/) }					
				it "should show the metadata mousehover on the title" do
					page.should have_xpath("//div[@id=\'#{Post.first.id}\'][@title=\'Posted less than a minute ago in New York\']") 
				end
			end									
		end
	
	end

	describe "no edit of published posts" do
		let!(:p) { FactoryGirl.create(:post, published: true) }
		before { visit edit_post_path(p) }
		it "should redirect to home" do
			current_path.should == new_post_path
			current_path.should_not == edit_post_path(p)
		end		
	end


end