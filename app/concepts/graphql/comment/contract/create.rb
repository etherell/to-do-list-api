# frozen_string_literal: true

module Graphql::Comment::Contract
  class Create < ApplicationContract
    property :text
    property :image

    validation :default do
      configure do
        config.namespace = :comment
      end

      required(:text).filled(:str?)
      optional(:image).maybe(:str?)
    end

    validation :size, if: :default do
      configure { config.namespace = :comment }

      required(:text).filled(:str?, size?: Constants::Shared::COMMENT_TEXT_SIZE_RANGE)
    end
  end
end
