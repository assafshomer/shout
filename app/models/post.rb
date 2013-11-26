# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#  published  :boolean          default(FALSE)
#  location   :string(255)
#

class Post < ActiveRecord::Base
	
	validates :content, length:  { minimum: 2 }
  default_scope -> { order('created_at DESC') }
  # scope :sort, -> { order('created_at DESC') }
  scope :published, -> {where(published: true)}
  scope :previewed, -> {where(published: false)}
  before_save { |post| post.content = post.content[0..2545].split("​").join } # 67*38

  def self.publication_tail(n=4)
  	published.sort_by! {|p| p.created_at}.reverse.first(n)
  end
end
