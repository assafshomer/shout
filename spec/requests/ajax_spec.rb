require 'spec_helper'

		describe "Ajax" do
		# 	before { visit root_path }
		# 	it "should create a new post" do
		# 		lambda do
		# 			xhr :post, :create
		# 		end.should change(Post, :count).by(1)
		# 	end
	 #   	it "should increment the Relationship count" do
	 #      expect do
	 #        xhr :post, :create, post: { content: 'test created by Ajax' }
	 #      end.to change(Post, :count).by(1)
	 #    end
	 #    it "should respond with success" do
	 #      xhr :post, :create, post: { content: 'test created by Ajax' }
	 #      response.should be_success
	 #    end
	 #  end		
		# describe "stream" do
		# 	describe "layout and ordering" do
		# 		let!(:rand_array) { random_array(100,8) }
		# 		let!(:cont_array) { rand_array.each.map {|x| "Test Post - #{x}" }}
		# 		let!(:post_array) { cont_array.each.map {|blurb| Post.new(content: blurb,
		# 		 created_at: ((random_array(100,1))[0]).days.ago) }}				
		# 		before do 
		# 			post_array.each { |post|	post.save }
		# 			visit root_path											
		# 		end
		# 		describe "clicking the post button with an empty post should raise an error" do
		# 			before { click_button button }
		# 			it { should have_selector('div.alert.alert-error', text: '2 errors') }
		# 		end
		# 		it { should have_selector('div.pagination') } 
		# 		it "should display each of the posts" do
		# 			post_array.sort {|x,y| x.created_at<=>y.created_at}.reverse[0..4].each do |post|
		# 				page.should have_selector("div##{post.id}", text: post.content) 		
		# 				page.should have_selector('span.timestamp', text: time_ago_in_words(post.created_at)) 
		# 			end
		# 		end
		# 		it "should display the search bar" do
		# 			page.should have_xpath("//input[@value=\'Search\']") 
		# 			page.should have_xpath("//input[@value=\'Clear\']") 
		# 			page.should have_selector('input#search') 
		# 		end
		# 		describe "should display posts in reverse chronological order" do
		# 			let!(:times) { Post.all.to_a.map(&:created_at) }
		# 			specify {times.should == times.sort.reverse}
		# 		end

		# 	end
		end		