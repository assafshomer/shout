require 'spec_helper'

describe "Layouts" do
	subject { page }
	before { visit root_path }
	it { should have_header }
end
