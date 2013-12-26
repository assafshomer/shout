require 'spec_helper'

describe SearchHelper do

  describe "generate_sql" do
    it "should be nil if no fields" do
      generate_sql("foo",'',nil)[0].should be_nil
    end
    it "should work with 1 search field" do
      generate_sql("foo", 'bar', nil).should ==["bar LIKE ? ", "%foo%"]
      generate_sql("foo", 'bar', nil,'=').should ==["bar LIKE ? ", "foo"]
    end          
    it "should work with 3 search fields" do
      generate_sql("foo", 'bar baz quux',nil).should ==
      ["bar LIKE ?  OR baz LIKE ?  OR quux LIKE ? ", "%foo%", "%foo%", "%foo%"]
      generate_sql("foo", 'bar baz quux',nil,'=').should ==
      ["bar LIKE ?  OR baz LIKE ?  OR quux LIKE ? ", "foo", "foo", "foo"]      
    end
    it "should work with 2 search fields and 2 search terms" do
      generate_sql("foo bar", 'buz quux',nil).should ==
      ["buz LIKE ?  OR buz LIKE ?  OR quux LIKE ?  OR quux LIKE ? ", "%foo%", "%bar%", "%foo%", "%bar%"]
      generate_sql("foo bar", 'buz quux',nil,'=').should ==
      ["buz LIKE ?  OR buz LIKE ?  OR quux LIKE ?  OR quux LIKE ? ", "foo", "bar", "foo", "bar"]      
    end
    it "should collapse duplicates" do
      generate_sql("foo foo foo buz buz foo", 'bar',nil).should ==
      ["bar LIKE ?  OR bar LIKE ? ", "%foo%", "%buz%"]
      generate_sql("foo foo foo buz buz foo", 'bar',nil,'=').should ==
      ["bar LIKE ?  OR bar LIKE ? ", "foo", "buz"]      
    end
    it "should collapse duplicates up to case for LIKE search" do
      generate_sql("foo FoO Foo buZ BUZ fOo", 'bar',nil).should ==
      ["bar LIKE ?  OR bar LIKE ? ", "%foo%", "%buz%"]
      generate_sql("foo FoO Foo buZ BUZ fOo", 'bar',nil,'=').should ==
      ["bar LIKE ?  OR bar LIKE ? ", "foo", "buz"]      
    end
    # it "should NOT collapse duplicates up to case for EQUAL search" do
    #   generate_sql("foo FoO Foo buZ BUZ fOo", 'bar',nil,'=').should ==
    #   ["bar = ?  OR bar = ?  OR bar = ?  OR bar = ?  OR bar = ?  OR bar = ? ", "foo", "FoO", "Foo", "buZ", "BUZ", "fOo"]      
    # end    
    it "should truncate search terms after 41 characters" do
      generate_sql("f"*50, 'bar',nil).should == generate_sql("f"*40, 'bar',nil)      
      generate_sql("f"*50, 'bar',nil).should_not == generate_sql("f"*39, 'bar',nil)
    end 
    it "should not include an illegal field" do
      generate_sql('foo bar', 'name email buz',Post).should == generate_sql('foo bar', 'name email',Post)
    end                               
  end
 
  describe "extract_minimal_search_terms" do
    it "should truncate duplicates" do
      extract_minimal_search_terms('a a b b a c').should == ['a','b','c']
    end
    it "ignore case" do
      extract_minimal_search_terms('aa aa aA Aa AA').should ==['aa']
    end
    # it "NOT ignore case for EQUAL search" do
    #   extract_minimal_search_terms('aa aA Aa AA','=').should ==['aa','aA','Aa','AA']
    #   extract_minimal_search_terms('aa aa aA Aa AA AA AA','=').should ==['aa','aA','Aa','AA']
    # end    
    it "should not choke on empty string" do
      extract_minimal_search_terms('').should == []
    end
    it "should keep full search term if not LIKE" do
      extract_minimal_search_terms('foo bar', '=').should == ['foo bar']
    end
  end

  describe "wrap_with_percent" do
    it "should wrap with percent for LIKE search" do
      wrap_with_percent(%w(assaf shomer)).should == ['%assaf%','%shomer%']  
    end    
    it "should NOT wrap with percent for EQUAL search" do
      wrap_with_percent(%w(assaf shomer),'=').should == ['assaf','shomer']  
    end      
    it "should not wrap an empty array" do
      wrap_with_percent([]).should == []
    end
  end

  describe "extract_legal_fields" do
    it "should include legal fields only" do
      extract_legal_fields('name foo bar content',Post).should == ['content']  
    end    
    it "should accept anything if field is nil" do
      extract_legal_fields('name foo bar content',nil).should == %W(name foo bar content)
      extract_legal_fields('name foo bar content',nil).should_not == %W(not this)
    end     
  end

  describe "generate_query" do
    it "should work with one search term and one field" do
      generate_query(['foo'],['bar']).should == 'bar LIKE ? '
      generate_query(['foo'],['bar']).should == 'bar LIKE ? '
    end
    it "should not choke on empty" do
      generate_query([],['bar']).should be_blank
      generate_query(['foo'],[]).should be_blank
      generate_query([],[]).should be_blank
    end   
    it "should work with 2 search terms" do
      generate_query(['foo','bar'],['baz','quux']).should == "baz LIKE ?  OR baz LIKE ?  OR quux LIKE ?  OR quux LIKE ? " 
      generate_query(['foo','bar'],['baz','quux']).should == "baz LIKE ?  OR baz LIKE ?  OR quux LIKE ?  OR quux LIKE ? " 
    end 
  end

  describe "generate_exact_sql" do
    it "should be nil if no fields" do
      generate_exact_sql("foo",'', nil)[0].should be_nil
    end
    it "should work with 1 search field" do
      generate_exact_sql("foo", 'bar', nil).should ==["bar LIKE ? ", "foo"]
    end          
    it "should work with 3 search fields" do
      generate_exact_sql("foo", 'bar baz quux',nil).should ==
      ["bar LIKE ?  OR baz LIKE ?  OR quux LIKE ? ", "foo", "foo", "foo"]      
    end
    it "should work with 2 search fields and 2 search terms" do
      generate_exact_sql("foo bar", 'buz quux',nil).should ==
      ["buz LIKE ?  OR quux LIKE ? ", "foo bar", "foo bar"]      
    end
    it "should NOT collapse duplicates" do
      generate_exact_sql("foo foo foo buz buz foo", 'bar',nil).should ==
      ["bar LIKE ? ", "foo foo foo buz buz foo"]      
    end
    it "should collapse duplicates up to case for LIKE search" do
      generate_exact_sql("foo FoO Foo buZ BUZ fOo", 'bar',nil).should ==
      ["bar LIKE ? ", "foo FoO Foo buZ BUZ fOo"]      
    end
    it "should truncate search terms after 41 characters" do
      generate_exact_sql("f"*50, 'bar',nil).should == generate_exact_sql("f"*40, 'bar',nil)      
      generate_exact_sql("f"*50, 'bar',nil).should_not == generate_exact_sql("f"*39, 'bar',nil)
    end 
    it "should not include an illegal field" do
      generate_exact_sql('foo bar', 'name email buz',Post).should == generate_exact_sql('foo bar', 'name email',Post)
    end                               
  end


  # describe "generate_LIKE_sql" do
  #    it "should be nil if no fields" do
  #      generate_LIKE_sql("foo",'',nil)[0].should be_nil
  #    end
  #    it "should work with 1 search field" do
  #      generate_LIKE_sql("foo", 'bar', nil).should ==["bar LIKE ? ", "%foo%"]
  #    end          
  #    it "should work with 3 search fields" do
  #      generate_LIKE_sql("foo", 'bar baz quux',nil).should ==
  #      ["bar LIKE ?  OR baz LIKE ?  OR quux LIKE ? ", "%foo%", "%foo%", "%foo%"]
  #    end
  #    it "should work with 2 search fields and 2 search terms" do
  #      generate_LIKE_sql("foo bar", 'buz quux',nil).should ==
  #      ["buz LIKE ?  OR buz LIKE ?  OR quux LIKE ?  OR quux LIKE ? ", "%foo%", "%bar%", "%foo%", "%bar%"]
  #    end
  #    it "should collapse duplicates" do
  #      generate_LIKE_sql("foo foo foo buz buz foo", 'bar',nil).should ==
  #      ["bar LIKE ?  OR bar LIKE ? ", "%foo%", "%buz%"]
  #    end
  #    it "should collapse duplicates up to case" do
  #      generate_LIKE_sql("foo FoO Foo buZ BUZ fOo", 'bar',nil).should ==
  #      ["bar LIKE ?  OR bar LIKE ? ", "%foo%", "%buz%"]
  #    end
  #    it "should truncate search terms after 41 characters" do
  #      generate_LIKE_sql("f"*50, 'bar',nil).should == generate_LIKE_sql("f"*40, 'bar',nil)      
  #      generate_LIKE_sql("f"*50, 'bar',nil).should_not == generate_LIKE_sql("f"*39, 'bar',nil)
  #    end 
  #    it "should not include an illegal field" do
  #      generate_LIKE_sql('foo bar', 'name email buz',Post).should == generate_LIKE_sql('foo bar', 'name email',Post)
  #    end                               
  #  end

  #  describe "generate_EQUAL_sql" do
  #    it "should be nil if no fields" do
  #      generate_EQUAL_sql("foo",'',nil)[0].should be_nil
  #    end
  #    it "should work with 1 search field" do
  #      generate_EQUAL_sql("foo", 'bar', nil).should ==["bar = ? ", "%foo%"]
  #    end          
  #    it "should work with 3 search fields" do
  #      generate_EQUAL_sql("foo", 'bar baz quux',nil).should ==
  #      ["bar = ?  OR baz = ?  OR quux = ? ", "%foo%", "%foo%", "%foo%"]
  #    end
  #    it "should work with 2 search fields and 2 search terms" do
  #      generate_EQUAL_sql("foo bar", 'buz quux',nil).should ==
  #      ["buz = ?  OR buz = ?  OR quux = ?  OR quux = ? ", "%foo%", "%bar%", "%foo%", "%bar%"]
  #    end
  #    it "should collapse duplicates" do
  #      generate_EQUAL_sql("foo foo foo buz buz foo", 'bar',nil).should ==
  #      ["bar = ?  OR bar = ? ", "%foo%", "%buz%"]
  #    end
  #    it "should collapse duplicates up to case" do
  #      generate_EQUAL_sql("foo FoO Foo buZ BUZ fOo", 'bar',nil).should ==
  #      ["bar = ?  OR bar = ? ", "%foo%", "%buz%"]
  #    end
  #    it "should truncate search terms after 41 characters" do
  #      generate_EQUAL_sql("f"*50, 'bar',nil).should == generate_EQUAL_sql("f"*40, 'bar',nil)      
  #      generate_EQUAL_sql("f"*50, 'bar',nil).should_not == generate_EQUAL_sql("f"*39, 'bar',nil)
  #    end 
  #    it "should not include an illegal field" do
  #      generate_EQUAL_sql('foo bar', 'name email buz',Post).should == generate_EQUAL_sql('foo bar', 'name email',Post)
  #    end                               
  #  end  

  # describe "generate_LIKE_query" do
  #   it "should work with one search term and one field" do
  #     generate_LIKE_query(['foo'],['bar']).should == 'bar LIKE ? '
  #   end
  #   it "should not choke on empty" do
  #     generate_LIKE_query([],['bar']).should be_blank
  #     generate_LIKE_query(['foo'],[]).should be_blank
  #     generate_LIKE_query([],[]).should be_blank
  #   end   
  #   it "should work with 2 search terms" do
  #     generate_LIKE_query(['foo','bar'],['baz','quux']).should == "baz LIKE ?  OR baz LIKE ?  OR quux LIKE ?  OR quux LIKE ? " 
  #   end 
  # end

  # describe "generate_EQUAL_query" do
  #   it "should work with one search term and one field" do
  #     generate_EQUAL_query(['foo'],['bar']).should == 'bar = ? '
  #   end
  #   it "should not choke on empty" do
  #     generate_EQUAL_query([],['bar']).should be_blank
  #     generate_EQUAL_query(['foo'],[]).should be_blank
  #     generate_EQUAL_query([],[]).should be_blank
  #   end   
  #   it "should work with 2 search terms" do
  #     generate_EQUAL_query(['foo','bar'],['baz','quux']).should == "baz = ?  OR baz = ?  OR quux = ?  OR quux = ? " 
  #   end 
  # end  
end