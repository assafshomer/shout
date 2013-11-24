module TestHelper

include ActionView::Helpers::DateHelper
include ViewsHelper
include MarkupHelper
include PostsHelper
include SessionsHelper

	def random_array(range, size)
		(1..range).to_a.sample size
	end

end