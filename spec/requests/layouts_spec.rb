require 'spec_helper'
require 'shared_examples'
include ViewsHelper

describe "Layouts" do
	subject { page }	
	before { visit new_post_path }
	it_should_behave_like 'all pages'
	it_should_behave_like 'a page with sidebar'
end
