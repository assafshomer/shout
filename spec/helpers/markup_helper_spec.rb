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
	
	process_cases={}
	process_cases[""]=""
	process_cases["`2 as`"]=PRE+"2em;>"+pulverize("as")+"</div>"
	process_cases["`3 a b  `"]=PRE+"3em;>"+pulverize("a b  ")+"</div>"
	process_cases["`4  as`"]=PRE+"4em;>"+pulverize(" as")+"</div>"
	process_cases["`5 a s bb`"]=PRE+"5em;>"+pulverize("a s bb")+"</div>"

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

	marked_urls={}
	marked_urls["`xxx|`"]=[]
	marked_urls["c a|http://b d"]=[["c a","http://b"]]
	marked_urls["`google|http://www.google.com`"]=[["`google","http://www.google.com"]]
	marked_urls["`1 google|http://www.google.com`"]=[["`1 google","http://www.google.com"]]
	marked_urls["yaa hoo|http://yahoo.com"]=[["yaa hoo","http://yahoo.com"]]
	marked_urls[" yaa hoo |http://yahoo.com"]=[["yaa hoo","http://yahoo.com"]]
	marked_urls[" ` yaa hoo |http://yahoo.com"]=[["` yaa hoo","http://yahoo.com"]]
	marked_urls["google| http://www.google.com"]=[["google","http://www.google.com"]]	
	marked_urls["google | http://www.google.com"]=[["google","http://www.google.com"]]
	marked_urls["google |http://www.google.com"]=[["google","http://www.google.com"]]	
	marked_urls["      google |  http://www.google.com"]=[["google","http://www.google.com"]]
	marked_urls["c|https:\\\\d"]=[["c","https:\\\\d"]]
	marked_urls["c|http://d e f|https://g h"]=[["c","http://d"],["e f","https://g"]]
	marked_urls["blah|foo c|http://d e f|https://g h"]=[["foo c","http://d"],["e f","https://g"]]
	marked_urls["blah://foo c|http://d e f|https://g h"]=[["blah://foo c","http://d"],["e f","https://g"]]
	marked_urls["http://foo.com|http://bar.baz"]=[["http://foo.com","http://bar.baz"]]
	
	bad_marked_urls={}
	bad_marked_urls["[ yaa hoo|http://yahoo.com]"]=[[" yaa hoo","http://yahoo.com"]] # this is due to regex groups trimming
	bad_marked_urls["c|http://d e f|http://g"]=[["c","http://d"],["f","http://k"]]

	build_url_cases={}
	build_url_cases["assaf"]=pulverize("assaf")
	build_url_cases["a|b"]=pulverize("a|b")
	build_url_cases["a|http://b"]="<a href=http://b>"+pulverize("a")+"</a>"
	build_url_cases["c a|http://b"]="<a href=http://b>"+pulverize("c a")+"</a>"
	build_url_cases["c a|http://b d"]="<a href=http://b>"+pulverize("c a")+"</a>"+pulverize(" d")

	badly_build_url_cases={}
	badly_build_url_cases["a|b"]="<a href=b>"+pulverize("a")+"</a>"
	badly_build_url_cases["a||http://b"]="<a href=http://b>"+pulverize("a")+"</a>"
	badly_build_url_cases["c a|http://b"]="<a href=http://b>"+pulverize(" c a")+"</a>"


	mark_cases={}
	mark_cases[""]=""
	mark_cases["assaf"]=pulverize("assaf")
	mark_cases["   assaf"]=pulverize("   assaf")
	mark_cases["` assaf`"]=pulverize("` assaf`")
	mark_cases["` assaf `"]=pulverize("` assaf `")
	mark_cases["`assaf`"]=pulverize("`assaf`")
	mark_cases["`3 `"]=""
	mark_cases["`2 as`"]=PRE+"2em;>"+pulverize("as")+"</div>"
	mark_cases["`2 a s bb`"]=PRE+"2em;>"+pulverize("a s bb")+"</div>"
	mark_cases["`2 as` b"]=PRE+"2em;>"+pulverize("as")+"</div>"+pulverize(" b")
	mark_cases["aa`3 bb`cc"]=pulverize("aa")+PRE+"3em;>"+pulverize("bb")+"</div>"+pulverize("cc")
	mark_cases["``1 nested``"]=pulverize("`")+PRE+"1em;>"+pulverize("nested")+"</div>"+pulverize("`")
	mark_cases["```1 n``"]=pulverize("``")+PRE+"1em;>"+pulverize("n")+"</div>"+pulverize("`")
	mark_cases[two_lines]=pulverize(two_lines)
	mark_cases[line_break]=pulverize(line_break)
	# mark_cases["`3 google|http://g.com`"]=
	# 	PRE+"3em;>"+'<a href="http://g.com">'+pulverize("google")+"</a>"+"</div>"
	# mark_cases["google|http://g.com`"]=pulverize("google|http://g.com")
	# 	PRE+"3em;>"+'<a href="http://g.com">'+pulverize("google")+"</a>"+"</div>"		
	# mark_cases["`2 a b |https://c`"]=
	# 	PRE+"2em;>"+'<a href="https://c">'+pulverize("a b ")+"</a>"+"</div>"
	# mark_cases["`2 a | b |https://c`"]=
	# 	PRE+"2em;>"+'<a href="https://c">'+pulverize(" b ")+"</a>"+"</div>"	
	# mark_cases["`2 a|http://b x c|http://d`"]=
	# 	PRE+"2em;>"+'<a href="http://b">'+pulverize("a")+"</a>"+pulverize(" x ")+
	# 	'<a href="http://d">'+pulverize("c")+"</a>"+"</div>"
	# mark_cases["a `2 x c|http://d`"]=
	# 	pulverize("a ")+PRE+"2em;>"+'<a href="http://d">'+pulverize("x c")+"</a>"+"</div>"		
	# mark_cases["a `2 x c|http://d` b `3 e` `4 http://w|http://w` f"]=pulverize("a ")+
	# 	PRE+"2em;>"+'<a href="http://d">'+pulverize("x c")+"</a>"+pulverize("b")+
	# 	PRE+"3em;>"+pulverize("e")+
	# 	PRE+"4em;>"+'<a href="http://w">'+pulverize("http://w")+"</a>"+pulverize(" f")+"</div>"							


	
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

	describe "extract marked url" do
		marked_urls.each do |k,v|
			specify{match_marked_url(k).should == v }	
		end		
	end	
	describe "extract bad marked url" do
		bad_marked_urls.each do |k,v|
			specify{match_marked_url(k).should_not == v }	
		end		
	end	
	describe "build urls" do
		build_url_cases.each do |k,v|
			specify{build_url(k).should == v }	
		end		
	end		
	describe "don't build urls" do
		badly_build_url_cases.each do |k,v|
			specify{build_url(k).should_not == v }	
		end		
	end		

	describe "markup" do
		markup_cases.each do |k,v|
			specify{markup(k).should == v}
		end
	end

	describe "process" do
		process_cases.each do |k,v|
			specify{process(k).should == v}
		end
	end

	describe "mark" do
		mark_cases.each do |k,v|
			specify{mark(k).should == '<pre>'+v+'</pre>'}
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