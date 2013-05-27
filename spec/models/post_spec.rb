# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Post do
 it { should respond_to(:content) }

 	describe "Empty posts should be invalid" do
 		before { @post=Post.new }
 		it { should_not be_valid }
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
