# frozen_string_literal: true

module Api::V1::Comment::Contract
  class Create < ApplicationContract
    property :text
    property :image

    validation :default do
      configure do
        config.namespace = :comment

        def valid_image?(value)
          return true unless value.content_type
          return false unless value.content_type.split('/').last.in?(ImageUploader.new.extension_allowlist)
          return false if value.size > Constants::Shared::IMAGE_MAX_SIZE

          true
        end
      end

      required(:text).filled(:str?)
      optional(:image).maybe(:valid_image?)
    end

    validation :size, if: :default do
      configure { config.namespace = :comment }

      required(:text).filled(:str?, size?: Constants::Shared::COMMENT_TEXT_SIZE_RANGE)
    end
  end
end
