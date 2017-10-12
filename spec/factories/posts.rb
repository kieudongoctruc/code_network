FactoryGirl.define do
  factory :post, class: ::Post do
    content Faker::Lorem.sentence
    association :creator, factory: :user
  end
end
