# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    description { FFaker::Lorem.unique.phrase }
    deadline { DateTime.now }
    position { rand(1..100) }
    is_done { false }
    project
  end
end
