require 'spec_helper'

space="a

b"

describe MarkupHelper do	

	match_box={}
	match_box["`1 assaf`"]=["`1 assaf`"]

	describe "find backticks" do
		match_box.each do |k,v|
			specify{find_backticks(k).should == v }	
		end		
	end

end