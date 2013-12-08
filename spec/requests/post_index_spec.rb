require 'spec_helper'
require 'shared_examples'
include TestHelper
include ViewsHelper

describe "index" do 
	subject { page }
	let!(:page_title) { index_title }		
	before do
		# Post.delete_all  
		(tile_count+5).times do 
			FactoryGirl.create(:post,content:"xx", published: true)
		end
  end	
  describe "search stream" do
  	describe "should have correct tile count without search or local posts" do
  		before { visit posts_path }
			it { should have_selector("li##{'search_tile_'+Post.first.id.to_s}") }	
			it { should have_selector("li##{'search_tile_'+Post.all[tile_count-1].id.to_s}") }	
			it { should_not have_selector("li##{'search_tile_'+Post.all[tile_count].id.to_s}") }	
  	end
		describe "with pagination" do
			let!(:preview2) { FactoryGirl.create(:post, content: "moonbuzz") }
			let!(:published2) { FactoryGirl.create(:post,content: "akuna mathata", published: true)  }
			before do
				visit posts_path
			end
			it_should_behave_like 'all pages'
			it_should_behave_like 'an index page'	
			it { should_not have_selector('td#local_stream') }	
			it { should_not have_content("no posts at this time") }			
			it { should have_selector('div.pagination#search') }
			describe "preview" do
				it { should_not have_selector("li##{'search_tile_'+preview2.id.to_s}", text: /#{pulverize(preview2.content,'\W')}/) }	
			end
			describe "publish" do
				it { should have_selector("li##{'search_tile_'+published2.id.to_s}", text: /#{pulverize(published2.content,'\W')}/) }					
			end					
			describe "tile count should be right with search and no local posts" do
				let!(:startid) { Post.ids.max+100 }
				let!(:latestid) { startid+tile_count*2-1 }
				before do
					(tile_count*2).times do |n|
						FactoryGirl.create(:post, published: true, content: "foogazi", id: startid+n)
					end 
					fill_in 'search', with: 'foogazi'
					click_button 'Search'
				end	
				it { should have_selector("li##{'search_tile_'+(latestid).to_s}") }	# the first was created last
				it { should have_selector("li##{'search_tile_'+(latestid-tile_count+1).to_s}") }	
				it { should_not have_selector("li##{'search_tile_'+(latestid-tile_count).to_s}") }	
			end
		end	  	
  end
  describe "local stream" do
  	describe "without location" do
  		before { visit posts_path } 
  		it_should_behave_like 'an index page'
  		it { should_not have_selector('td#local_stream') }
  		it { should_not have_content('no local posts at this time') }
  		it { should_not have_selector('p#local_title', text: 'Local posts from') }
  	end
  	describe "with location but no local posts" do
  		let!(:loc) { 'Dimona' }
			before do
				visit signin_path
				fill_in 'location', with: loc
				click_button signin_button_title
				visit posts_path
			end
  		it { should have_selector('td#local_stream') }
  		it { should have_content('no local posts at this time') }			 		
  	end
		describe "with location and local posts" do
			let!(:loc) { 'Tehran' }
			let!(:pre3) { FactoryGirl.create(:post, content: "fuckbuttons", location: loc) }
			let!(:pub3) { FactoryGirl.create(:post,content: "grandaddy hohoho",	published: true, location: loc)  }
			before do
				visit signin_path
				fill_in 'location', with: loc
				click_button signin_button_title
				(tile_count*2).times do
					FactoryGirl.create(:post, published: true, content: "humus", location: loc)
				end 				
				visit posts_path
			end
			it_should_behave_like 'all pages'
			it_should_behave_like 'an index page'		
			it { should_not have_content("no local posts at this time") }			
			it { should have_selector('p#local_title', text: 'Local posts from '+loc) }
			it { should have_selector('div.pagination#local') }
			describe "preview" do
				it { should_not have_selector("li##{'local_tile_'+pre3.id.to_s}") }	
			end
			describe "local stream tile count should be right" do
				let!(:localposts) { Post.where("location = 'Tehran'") }
				it { should have_selector("li##{'local_tile_'+localposts.first.id.to_s}", text: /#{pulverize('humus','\W')}/) }					
				it { should have_selector("li##{'local_tile_'+localposts[tile_count(2) -1].id.to_s}") }					
				it { should_not have_selector("li##{'local_tile_'+localposts[tile_count(2)].id.to_s}") }			
			end	
			describe "search stream tile count should be halved" do
				it { should have_selector("li##{'search_tile_'+Post.first.id.to_s}") }	
				it { should have_selector("li##{'search_tile_'+Post.all[tile_count(2)-1].id.to_s}") }	
				it { should_not have_selector("li##{'search_tile_'+Post.all[tile_count(2)].id.to_s}") }					
			end
			describe "after zeroing out location" do
				before do
					visit signin_path
					fill_in 'location', with: ''
					click_button signin_button_title
					visit posts_path
				end
				it { should_not have_selector('td#local_stream') }	
				it { should_not have_content("no local posts at this time") }						
				describe "search stream tile count should be full" do
					it { should have_selector("li##{'search_tile_'+Post.first.id.to_s}") }	
					it { should have_selector("li##{'search_tile_'+Post.all[tile_count(1)-1].id.to_s}") }	
					it { should_not have_selector("li##{'search_tile_'+Post.all[tile_count(1)].id.to_s}") }					
				end								
			end
			describe "after changing location to a location without local posts" do
				before do
					visit signin_path
					fill_in 'location', with: 'The moon'
					click_button signin_button_title
					visit posts_path
				end
				it { should have_selector('td#local_stream') }	
				it { should have_content("no local posts at this time for The moon") }						
				describe "search stream tile count should be full" do
					it { should have_selector("li##{'search_tile_'+Post.first.id.to_s}") }	
					it { should have_selector("li##{'search_tile_'+Post.all[tile_count(2)-1].id.to_s}") }	
					it { should_not have_selector("li##{'search_tile_'+Post.all[tile_count(2)].id.to_s}") }					
				end								
			end			
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
			  # save_and_open_page
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
			it_should_behave_like 'an index page'				
			it { should_not have_selector('div.pagination') }
			it { should_not have_selector("li##{'local_tile_'+preview1.id.to_s}", text: /#{pulverize(preview1.content,'\W')}/) }	
			it { should have_content("no posts at this time") }				
		end
		describe "publish" do
			let!(:published1) { FactoryGirl.create(:post, content: "buzz quuaax", published: true)  }
			before {visit posts_path}
			it_should_behave_like 'all pages'
			it_should_behave_like 'an index page'					
			it { should_not have_selector('div.pagination') }
			it { should have_selector("li##{'search_tile_'+published1.id.to_s}", text: /#{pulverize(published1.content,'\W')}/) }					
			it { should_not have_content("no posts at this time") }	
		end		
	end	
	describe "metadata hover" do
		describe "for newly published post WITHOUT location" do
			before do
			  visit new_post_path
			  fill_in 'inputbox', with: 'testing metadata'
			  click_button preview_button_title
			  click_button publish_button_title
			  visit posts_path
			  # save_and_open_page
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
