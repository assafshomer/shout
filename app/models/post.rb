# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#  published  :boolean          default(FALSE)
#

class Post < ActiveRecord::Base
	
	validates :content, length:  { minimum: 2 }
  default_scope -> { order('created_at DESC') }
  scope :published, -> {where(published: true)}
  scope :previewed, -> {where(published: false)}
  before_save { |post| post.content = post.content[0..2545].split("​").join } # 67*38

end
