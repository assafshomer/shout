require 'spec_helper'
require 'shared_examples'
include TestHelper

describe "Static" do
	subject { page }

  describe "Home page" do
  	let!(:page_title) { "Home" }
  	before { visit root_path }
  	it_should_behave_like 'all pages'  	
    it { should have_selector('div.cheatsheet') }
    it { should have_content "The Rules" }
    it { should have_selector('li.tile') }
    it { should have_selector("a#tile_#{Post.published.first.id}", 
      href="#{post_path(Post.published.first)}")}
  end

  describe "Help page" do
    before { visit help_path }
    let(:page_title) {'Help'}
    it_should_behave_like "all pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:page_title) {'About'}
    it_should_behave_like "all pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:page_title) {'Contact'}
    it_should_behave_like "all pages"
  end 

  it "should have the right links on the layout" do
    visit root_path
    # click_link "About"
    # page.should have_title full_title('About')
    # click_link "Help"
    # page.should have_title full_title('Help')
    # click_link "Contact"
    # page.should have_title full_title('Contact')
    click_link app_title
    page.should have_title full_title('Home')
  end  
end