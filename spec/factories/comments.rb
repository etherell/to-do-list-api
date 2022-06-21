# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    text { FFaker::Lorem.unique.phrase }
    image do
      path = Rails.root.join('spec/fixtures/images/default.jpg')
      Rack::Test::UploadedFile.new(path, 'image/jpg')
    end
    task

    trait :with_base_64_image do
      image do
        "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABmJL
        R0QA/wD/AP+gvaeTAAAAw0lEQVRIie2VUQrCMAyGv4mgIL4JnkXwAO4A7kLiBcRT+ORlBJ8Epy
        /iGUb3skCtm0kdgoP9EEhDkr/9W1Lo8SUyYF35W8AZbGVtPgMewBOYAyPgZCC4AlMLwcErOlaxBVAY
        SHZa86ymSKTaGwgKYNnUXKQJi0SqCXAxkJyBsSZNaCJVaiBwwOajTp1C4vnOmKvlveQPYncUi58TDF
        vWJ8H6Tb7uS/T3d6A+Wf8E95ZkPm51wRTIaZ4vAm0O5UR8Pj0oARHoaKqfoYIoAAAAAElFTkSuQmCC"
      end
    end
  end
end
