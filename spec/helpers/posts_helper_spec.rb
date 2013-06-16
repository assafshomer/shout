require 'spec_helper'

describe PostsHelper do	
	describe "wrap" do
		describe "should remove all new lines" do
			specify{wrap('string string').should == 'string string'}
			specify{wrap('a'*31).should_not == 'a'*31}
		end	
	end



end