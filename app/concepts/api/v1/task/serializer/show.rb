# frozen_string_literal: true

module Api::V1::Task::Serializer
  class Show < ApplicationSerializer
    attribute :description

    set_type :task
  end
end
