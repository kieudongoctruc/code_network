class User < ApplicationRecord
  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :username, presence: true, uniqueness: true
  validates :email, allow_blank: true, uniqueness: true, format: { with: EMAIL_REGEX }
end
