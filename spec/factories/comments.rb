FactoryGirl.define do
  factory :comment, class: ::Comment do
    content Faker::Lorem.sentence
    association :creator, factory: :user
    association :post, factory: :post
  end
end
