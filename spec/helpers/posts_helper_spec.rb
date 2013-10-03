require 'spec_helper'

space="a

b"

too_long="1\r\n2\r\n3\r\n4\r\n5\r\n6\r\n7\r\n8\r\n9\r\n10\r\n11\r\n12\r\n13\r\n14\r\n15\r\n16\r\n17\r\n18\r\n19\r\n20\r\n21\r\n22\r\n23\r\n24\r\n25\r\n26\r\n27\r\n28\r\n29\r\n30\r\n31\r\n32\r\n33\r\n34\r\n35\r\n36\r\n37\r\n38\r\n39\r\n40\r\n41"
one_too_wide="a"*68
how_long="a"*13

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
			specify{how_long.size.should == 13}
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