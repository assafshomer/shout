require 'spec_helper'

describe MarkupHelper do	

	match_box={}
	match_box["`1 assaf`"]=["`1 assaf`"]
	match_box["`1 assaf` shomer"]=["`1 assaf`"]
	match_box["`1 assaf` `2 shomer"]=["`1 assaf`"]
	match_box["`1 assaf` `2 shomer`"]=["`1 assaf`", "`2 shomer`"]
	match_box["`1 a\r\nb` `2 shomer`"]=["`1 a\r\nb`", "`2 shomer`"]
	match_box["`10 assaf` `2 shomer`"]=["`10 assaf`", "`2 shomer`"]
	match_box["`567 assaf` `2 shomer`"]=["`567 assaf`", "`2 shomer`"]
	match_box["`567assaf` `2 shomer`"]=["`2 shomer`"]
	match_box["`567  assaf`"]=["`567  assaf`"]
	match_box["`56`7  assaf`"]=["`7  assaf`"]
	match_box["`1  ass`"]=["`1  ass`"]	
	match_box["`567 a s s a f   `"]=["`567 a s s a f   `"]
	match_box["`567 assaf` born in `2 shomer` is going to succee'''d in this '3 mission\`"]=
	["`567 assaf`", "`2 shomer`"]

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

	describe "extract backticks" do
		match_box.each do |k,v|
			specify{extract_backticks(k).should == v }	
		end		
	end

	describe "markup" do
		markup_cases.each do |k,v|
			specify{markup(k).should == v}
		end
	end

end