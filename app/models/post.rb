class Post < ApplicationRecord
  # == Model relationships
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  has_many :comments

  # == Validations
  validates :content, presence: true
  validates :creator_id, presence: true
end
