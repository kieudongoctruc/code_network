class Post < ApplicationRecord
  # == Model relationships
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  # == Validations
  validates :content, presence: true
  validates :creator_id, presence: true
end
