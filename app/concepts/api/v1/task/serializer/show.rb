# frozen_string_literal: true

module Api::V1::Task::Serializer
  class Show < ApplicationSerializer
    attribute :description, :position, :is_done, :deadline

    set_type :task
  end
end
