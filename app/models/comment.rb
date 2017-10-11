class Comment < ApplicationRecord
  # == Model relationships
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  belongs_to :post

  # == Validations
  validates :content, presence: true
  validates :creator_id, presence: true
  validates :post_id, presence: true
end
