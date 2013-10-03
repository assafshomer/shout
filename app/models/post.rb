# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class Post < ActiveRecord::Base
	
	validates :content, presence: :true,  length:  { minimum: 2 }
  default_scope -> { order('created_at DESC') }

  before_save { |post| post.content = post.content[0..2545] } # 67*38

end
