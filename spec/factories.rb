include ViewsHelper

FactoryGirl.define do 	
	
		factory :post do
			sequence(:content) {|n| ViewsHelper::fake_content}			
		end

end