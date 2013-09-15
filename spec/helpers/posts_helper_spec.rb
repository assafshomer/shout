require 'spec_helper'

space="a

b"

describe PostsHelper do	
	describe "new_wrap" do
		describe "should remove all new lines" do
			specify{new_wrap('string string').should == 'string string'}
			specify{new_wrap('a'*(max_length+1)).should_not == 'a'*(max_length+1)}						
			specify{new_wrap('a'*(max_length-1)+"<br/>"+'v').should == 'a'*(max_length-1)+"<br />"+'v' }
			specify{new_wrap('a'*(max_length+1)+"<br/>"+'v').should == 'a'*max_length+"&#8203;"+'a'+"<br />"+'v' }
			specify{new_wrap('assaf <br /> shomer').should == 'assaf <br /> shomer'}
			specify{new_wrap("a\r\nb").should == 'a<br />b'}
			specify{new_wrap("assaf\nshomer\n\nis").should == 'assaf<br />shomer<br /><br />is'}
			specify{new_wrap(space).should == 'a<br /><br />b'}
		end	
	end

	describe "replace_newline_with_br" do
		specify{replace_newline_with_br("a\nb\nc" ).should == "a<br/>b<br/>c" }
		specify{replace_newline_with_br("a\n\nb\nc" ).should == "a<br/><br/>b<br/>c" }
		specify{replace_newline_with_br("a\n\n\n" ).should == "a" }
		specify{replace_newline_with_br("\n\n\na" ).should == "a" }
		specify{replace_newline_with_br("\n\n\na\nb\n\n\n" ).should == "a<br/>b" }
	end

	describe "smart wrap" do
		specify{smart_wrap('a'*(max_length+1)+"<br/>"+'bc').should == 'a'*max_length+"&#8203;"+'a'+"<br/>"+'bc'}
		specify{smart_wrap('a'*(max_length-1)+"<br/>"+'bc').should == 'a'*(max_length-1)+"<br/>"+'bc'}		
	end

end