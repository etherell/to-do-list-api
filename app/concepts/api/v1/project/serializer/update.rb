# frozen_string_literal: true

module Api::V1::Project::Serializer
  class Update < ApplicationSerializer
    attribute :title

    set_type :project

    attribute :in_time_percentage do |_object, params|
      params[:in_time_percentage]
    end

    attribute :overdue_percantage do |_object, params|
      params[:overdue_percantage]
    end
  end
end
