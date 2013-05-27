require 'spec_helper'

describe "Layouts" do
	subject { page }
	before { visit root_path }
	it { should have_selector('header.navbar.navbar-fixed-top.navbar-inverse') }
	it { should have_link('Home', href: root_path) }
	it { should have_link('Posts', href: posts_path) }
end
