# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { FFaker::Lorem.unique.word }
    user
  end
end
