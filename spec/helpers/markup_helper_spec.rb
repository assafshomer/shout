require 'spec_helper'
include MarkupHelper
	space="

	"
	hebrew_with_space="אודות

סטודיו פראנה בתל אביב"

	heb_with_ticks="פראנה `5 יוגה` הוא"

	chinese="Chinese (汉`2 语/漢`語 Hànyǔ or `10 中文` Zhōngwén)"

	two_lines="of.
After"
	line_break="before \r\n after"

	extract_cases={}
	extract_cases["`1 `"]=[]
	extract_cases["`1 assaf`"]=["`1 assaf`"]
	extract_cases["`1 assaf` shomer"]=["`1 assaf`"]
	extract_cases["my name is `1 assaf` shomer"]=["`1 assaf`"]
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
	extract_cases[chinese]=["`2 语/漢`","`10 中文`"]
	extract_cases["assaf `1 a` shomer"]=["`1 a`"]

	split_cases={}
	split_cases["`1 `"]=[]
	split_cases["`1 assaf`"]=[]
	split_cases["`1 assaf` shomer"]=[" shomer"]
	split_cases["my name is `1 assaf` shomer"]=["my name is "," shomer"]
	split_cases["assaf `1 a` shomer"]=["assaf "," shomer"]

	markup_cases={}
	markup_cases["`2 assaf`"]=PRE+"2em;>assaf</div>"
	markup_cases["`2 assaf` and `45 shomer` but not `4 blue"]=
	PRE+"2em;>assaf</div> and "+
	PRE+"45em;>shomer</div>"+" but not `4 blue"
	markup_cases["`2 a\r\n ` x `45  s` y \n z `4 `w "]=
	PRE+"2em;>a\r\n </div> x "+	PRE+"45em;> s</div>"+" y \n z `4 `w "
	markup_cases["`2 a\r\n ` x `45  ss` y \n z `4 `w "]=
	PRE+"2em;>a\r\n </div> x "+	PRE+"45em;> ss</div>"+" y \n z `4 `w "
	markup_cases[heb_with_ticks]="פראנה <div class=mark style=font-size:5em;>יוגה</div> הוא"
	
	mnp_cases={}
	mnp_cases[""]=""
	mnp_cases["`2 as`"]=PRE+"2em;>"+pulverize("as")+"</div>"
	mnp_cases["`2 a b  `"]=PRE+"2em;>"+pulverize("a b  ")+"</div>"
	mnp_cases["`2  as`"]=PRE+"2em;>"+pulverize(" as")+"</div>"
	mnp_cases["`2 a s bb`"]=PRE+"2em;>"+pulverize("a s bb")+"</div>"

	url_cases={}
	url_cases["http://www.google.com"]=["http://www.google.com"]
	url_cases["https://g"]=["https://g"]
	url_cases["http://1.com"]=["http://1.com"]
	url_cases["http://1.com."]=["http://1.com."]
	url_cases["http://$.com"]=[]
	url_cases["http://_.google.com"]=[]
	url_cases["htt://www.google.com"]=[]
	url_cases["http://a blue https:\\\\b"]=['http://a',"https:\\\\b"]
	url_cases["1http://a blue https:\\\\b"]=['http://a',"https:\\\\b"]
	url_cases["http://https://a"]=['http://https']
	


	mark_cases={}
	mark_cases[""]='<pre>'+""+'</pre>'
	mark_cases["assaf"]='<pre>'+pulverize("assaf")+'</pre>'
	mark_cases["   assaf"]='<pre>'+pulverize("   assaf")+'</pre>'
	mark_cases["`3 `"]='<pre>'+""+'</pre>'
	mark_cases["`2 as`"]='<pre>'+PRE+"2em;>"+pulverize("as")+"</div>"+'</pre>'
	mark_cases["`2 a s bb`"]='<pre>'+PRE+"2em;>"+pulverize("a s bb")+"</div>"+'</pre>'
	mark_cases["`2 as` b"]='<pre>'+PRE+"2em;>"+pulverize("as")+"</div>"+pulverize(" b")+'</pre>'
	mark_cases["aa`3 bb`cc"]='<pre>'+pulverize("aa")+PRE+"3em;>"+pulverize("bb")+"</div>"+pulverize("cc")+'</pre>'
	mark_cases["``1 nested``"]='<pre>'+pulverize("`")+PRE+"1em;>"+pulverize("nested")+"</div>"+pulverize("`")+'</pre>'
	mark_cases["```1 n``"]='<pre>'+pulverize("``")+PRE+"1em;>"+pulverize("n")+"</div>"+pulverize("`")+'</pre>'
	mark_cases[two_lines]='<pre>'+pulverize(two_lines)+'</pre>'
	mark_cases[line_break]='<pre>'+pulverize(line_break)+'</pre>'



	mark_link={}
	# mark_link["goog|http://www.google.com"]='<pre><a href="http://www.google.com">'+pulverize("goog")+'</a></pre>'

describe MarkupHelper do	
	describe "extract backticks" do
		extract_cases.each do |k,v|
			specify{extract_backticks(k).should == v }	
		end		
	end

	describe "extract compliments" do
		split_cases.each do |k,v|
			specify{extract_compliment(k).should == v }	
		end		
	end

	describe "extract url" do
		url_cases.each do |k,v|
			specify{match_url(k).should == v }	
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

	describe "mark" do
		mark_cases.each do |k,v|
			specify{mark(k).should == v}
		end
	end	

	describe "mark" do
		mark_link.each do |k,v|
			specify{mark(k).should == v}
		end
	end		

	describe "pulverize" do
		specify{pulverize('aaa').should == 'a&#8203;a&#8203;a&#8203;'}
		specify{pulverize('a a  a').should == 'a&#8203; a&#8203;  a&#8203;'}
		specify{pulverize(' a  ').should == ' a&#8203;  '}
		specify{pulverize("aa\r\na").should == "a&#8203;a&#8203;\r\na&#8203;"}
		specify{pulverize(space).should == space}
		specify{pulverize(" ").should == " "}
		specify{pulverize("`").should == "`&#8203;"}
		specify{pulverize('`!@#{$}').should == '`&#8203;!&#8203;@&#8203;#&#8203;{&#8203;$&#8203;}&#8203;'}
	end


end