class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :author, class_name: 'User'

  validates :user, :text, presence: true
  validates_length_of :text, :maximum => 255

end
