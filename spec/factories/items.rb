require 'random_data'

FactoryGirl.define do
  factory :item do
    name RandomData.random_sentence
    user nil
    completed false
  end
end
