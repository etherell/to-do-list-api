# frozen_string_literal: true

module Api::V1::Project::Serializer
  class Index < ApplicationSerializer
    attribute :title

    set_type :project
  end
end
