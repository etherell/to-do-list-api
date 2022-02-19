# frozen_string_literal: true

module Api::V1::Comment::Serializer
  class Show < ApplicationSerializer
    attribute :text, :image_url

    set_type :comment
  end
end
