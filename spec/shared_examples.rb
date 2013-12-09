shared_examples_for "all pages" do 
	it { should have_selector('header.navbar.navbar-fixed-top.navbar-inverse') }
	it { should have_selector('footer.footer') }
	it { should have_link(tile_title, href: posts_path) }
  it { should have_link(new_title, href: new_post_path) }
	it { should have_link(app_title, href: root_path) }		
  it { should have_selector('a#location', href="#{signin_path}")}  
end	

shared_examples_for "a page with sidebar" do
  it { should have_selector('div.cheatsheet') }
  it { should have_content cheatsheet_text }
  it { should have_selector('li.tile') }
  it { should have_selector("a#search_link_#{Post.published.first.id}", 
    href="#{post_path(Post.published.first)}")}
  it { should have_link(shapes_text.strip, href: shapes_path) }
 end

shared_examples_for "an index page" do 
  it { should_not have_selector('textarea#inputbox') }    
  it { should_not have_selector('input#preview_button') }   
  it { should_not have_selector('input#publish_button') }     
  it { should have_selector('td#search_stream') }
  it { should have_selector('p#search_title', text: search_title) }
  it { should have_selector('input#search')}
  it { should have_button 'Search'}
  it { should have_button 'Clear'}
end  