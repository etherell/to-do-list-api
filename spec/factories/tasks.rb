# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    description { FFaker::Lorem.unique.phrase }
    deadline { DateTime.now }
    project
  end
end
