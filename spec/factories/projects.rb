# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { FFaker::Lorem.unique.phrase }
    user
  end
end
