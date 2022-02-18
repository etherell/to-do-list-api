# frozen_string_literal: true

module Api::V1::Project::Serializer
  class Show < ApplicationSerializer
    attribute :title

    set_type :project
  end
end
