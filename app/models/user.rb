class User < ApplicationRecord
  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  # == Model relationships
  has_many :posts, foreign_key: 'creator_id', dependent: :destroy
  has_many :comments, foreign_key: 'creator_id', dependent: :destroy

  # == Validations
  validates :username, presence: true, uniqueness: true
  validates :email, allow_blank: true, uniqueness: true, format: { with: EMAIL_REGEX }
end
