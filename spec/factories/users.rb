# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { "#{FFaker::InternetSE.unique.login_user_name} #{FFaker::InternetSE.login_user_name}" }
    password { 'Valid123' }
    password_confirmation { password }
  end
end
