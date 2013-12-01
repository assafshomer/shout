# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#  published  :boolean          default(FALSE)
#  location   :string(255)
#

require 'spec_helper'
include TestHelper

describe Post do
	describe "class methods" do
		it {Post.should respond_to(:publication_tail)	 }
		describe "publication_tail" do
			it { Post.publication_tail.should include(Post.published.first) }
			# it { Post.published.map(&:created_at).should be_nil}
			# it { Post.publication_tail.map {|p| time_ago_in_words(p.created_at)}.should be_nil }
			it { Post.publication_tail.should_not include(Post.previewed.first) }
		end
	end

	before(:each) do
	  @attr={}
	  @post=Post.new(@attr)
	end
 	subject { @post }
 	
 	it { should respond_to(:content) }
 	it { should respond_to(:published) }
 	it { should respond_to(:location) }
 	
 
	describe "validations" do
		describe "Empty posts should be invalid" do
	 		before { @post=Post.new }
	 		it { should_not be_valid }
	 	end
		describe "Empty posts should not be published" do
	 		before { @post=Post.new }
	 		it { should_not be_published }
	 	end	 	
	 	describe "Posts should include at least 2 characters" do
	 		before { @post=Post.new(content: 'x') }
	 		it { should_not be_valid }
	 	end
	 	describe "OK is a legal post" do
	 		before { @post=Post.new(content: 'OK') }
	 		it { should be_valid }
	 	end 	
	end

	describe "truncation to atmost 2546 characters" do
		let!(:toolong) { FactoryGirl.create(:post, content: "1"*3000) }
		let!(:normal) { FactoryGirl.create(:post) }
		specify {toolong.content.length.should == 2546}
		specify {normal.content.length.should < 2546}
	end

	describe "trim ZWSP" do
		let!(:string_with_ZWSP) { "`2 assafa​s​s​a​f`" }
		before { Post.create(content: string_with_ZWSP) }
		specify {Post.first.content.should == string_with_ZWSP.split("​").join }
		specify {Post.first.content.should_not == string_with_ZWSP }
	end

end
