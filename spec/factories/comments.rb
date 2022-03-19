# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    text { FFaker::Lorem.unique.phrase }
    image do
      path = Rails.root.join('spec/fixtures/images/default.jpg')
      Rack::Test::UploadedFile.new(path, 'image/jpg')
    end
    task
  end
end
