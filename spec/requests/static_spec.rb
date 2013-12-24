require 'spec_helper'
require 'shared_examples'
include TestHelper
include ViewsHelper

describe "Static" do
	subject { page }

  describe "Home page" do
    before { visit root_path }
    it_should_behave_like 'all pages'   
    it { should have_title full_title(home_title) }
    it { should have_selector('div.opaque')}
    it { should have_selector('div.shiny')}
    it { should have_content catch_phrase }
    it { should have_content elevator_pitch }
    it { should have_link('signinbutton', {href: signin_path}) }
    it { should have_link('newbutton', {href: new_post_path}) }
    it { should have_link('indexbutton', {href: posts_path}) }
  end 

  describe "Compose page" do
  	before { visit new_post_path }
  	it_should_behave_like 'all pages'  	
    it_should_behave_like 'a page with sidebar'
    it { should have_title full_title(new_title) }
  end

  describe "Help page" do
    before { visit help_path }
    let(:page_title) {'Help'}
    it_should_behave_like "all pages"
    it { should have_title full_title("Help") }
  end

  describe "Shapes page" do
    before { visit shapes_path }
    it { should have_title full_title(shapes_title) }
    it_should_behave_like "all pages"
    it { should_not have_content "♥" }
    it { should have_content "♜" }
    it { should have_selector('div.pagination') }
    describe "clicking on pagination link" do
      before { click_link 4 }
      it { should have_content "♥" }
      it { should_not have_content "♜" }      
    end
  end  

  describe "About page" do
    before { visit about_path }
    it { should have_title full_title("About") }
    it_should_behave_like "all pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    it { should have_title full_title("Contact") }
    it_should_behave_like "all pages"
  end 

  it "should have the right links on the layout" do
    visit new_post_path
    # click_link "About"
    # page.should have_title full_title('About')
    # click_link "Help"
    # page.should have_title full_title('Help')
    # click_link "Contact"
    # page.should have_title full_title('Contact')
    # click_link app_title
    page.should have_title full_title(new_title)
  end  
end