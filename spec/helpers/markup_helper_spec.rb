require 'spec_helper'
include MarkupHelper
	space="

	"
	hebrew="אודות

סטודיו פראנה בתל אביב"

	heb_with_ticks="פראנה `5 יוגה` הוא"

	extract_cases={}
	extract_cases["`1 assaf`"]=["`1 assaf`"]
	extract_cases["`1 assaf` shomer"]=["`1 assaf`"]
	extract_cases["`1 assaf` `2 shomer"]=["`1 assaf`"]
	extract_cases["`1 assaf` `2 shomer`"]=["`1 assaf`", "`2 shomer`"]
	extract_cases["`1 a\r\nb` `2 shomer`"]=["`1 a\r\nb`", "`2 shomer`"]
	extract_cases["`10 assaf` `2 shomer`"]=["`10 assaf`", "`2 shomer`"]
	extract_cases["`567 assaf` `2 shomer`"]=["`567 assaf`", "`2 shomer`"]
	extract_cases["`567assaf` `2 shomer`"]=["`2 shomer`"]
	extract_cases["`567  assaf`"]=["`567  assaf`"]
	extract_cases["`56`7  assaf`"]=["`7  assaf`"]
	extract_cases["`1  ass`"]=["`1  ass`"]	
	extract_cases["`567 a s s a f   `"]=["`567 a s s a f   `"]
	extract_cases["`567 assaf` born in `2 shomer` is going to succee'''d in this '3 mission\`"]=
	["`567 assaf`", "`2 shomer`"]
	extract_cases[heb_with_ticks]=["`5 יוגה`"]

	markup_cases={}
	markup_cases["`2 assaf`"]="<div style=font-size:2em;line-height:0.8em;>assaf</div>"
	markup_cases["`2 assaf` and `45 shomer` but not `4 blue"]=
	"<div style=font-size:2em;line-height:0.8em;>assaf</div> and "+
	"<div style=font-size:45em;line-height:0.8em;>shomer</div>"+" but not `4 blue"
	markup_cases["`2 a\r\n ` x `45  s` y \n z `4 `w "]=
	"<div style=font-size:2em;line-height:0.8em;>a\r\n </div> x "+
	"<div style=font-size:45em;line-height:0.8em;>s</div>"+" y \n z `4 `w "
	markup_cases["`2 a\r\n ` x `45  ss` y \n z `4 `w "]=
	"<div style=font-size:2em;line-height:0.8em;>a\r\n </div> x "+
	"<div style=font-size:45em;line-height:0.8em;>ss</div>"+" y \n z `4 `w "
	markup_cases[heb_with_ticks]="פראנה <div style=font-size:5em;line-height:0.8em;>יוגה</div> הוא"


	mnp_cases={}
	mnp_cases[""]=""
	mnp_cases["`2 as`"]="<div style=font-size:2em;line-height:0.8em;>"+pulverize("as")+"</div>"
	mnp_cases["`2 a s bb`"]="<div style=font-size:2em;line-height:0.8em;>"+pulverize("a s bb")+"</div>"
	mnp_cases["`2 as` b"]="<div style=font-size:2em;line-height:0.8em;>"+pulverize("as")+"</div>"+pulverize(" b")

describe MarkupHelper do	
	describe "extract backticks" do
		extract_cases.each do |k,v|
			specify{extract_backticks(k).should == v }	
		end		
	end

	describe "markup" do
		markup_cases.each do |k,v|
			specify{markup(k).should == v}
		end
	end

	describe "mark_and_pulverize" do
		mnp_cases.each do |k,v|
			specify{mark_and_pulverize(k).should == v}
		end
	end

	describe "pulverize" do
		specify{pulverize('aaa').should == 'a&#8203;a&#8203;a&#8203;'}
		specify{pulverize('a a  a').should == 'a&#8203; a&#8203;  a&#8203;'}
		specify{pulverize("aa\r\na").should == "a&#8203;a&#8203;\r\na&#8203;"}
		specify{pulverize(space).should == space}
	end


	describe "prepare" do
		specify{prepare("<div>").should == ""}
		specify{prepare("<div>blah</div>").should == pulverize("blah")}
		# specify{prepare("<div style=font-size:15em;>blah</div>").should == "blah"}
		# specify{prepare("<a href=b/>").should == ""}
		# specify{prepare("<table><tr><td>cell</td></tr></table>").should == "cell"}
	end

	# describe "mark_and_pulverize" do
	# 	specify{mark_and_pulverize("`5 aaa` bb").should ==
	# 	 "<div style=font-size:5em;line-height:0.8em;>"+pulverize('aaa')+"</div> bb"}
	# end
	



end