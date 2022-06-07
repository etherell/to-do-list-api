# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { FFaker::Lorem.phrase }
    user
  end
end
