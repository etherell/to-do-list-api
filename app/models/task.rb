# frozen_string_literal: true

class Task < ApplicationRecord
  include PgSearch::Model

  multisearchable against: :description

  OVERDUE_STATUSES = { in_time: 0, overdue: 1 }.freeze

  belongs_to :project
  has_many :comments, dependent: :destroy

  acts_as_list scope: :project

  enum overdue_status: OVERDUE_STATUSES

  scope :done, -> { where(is_done: true) }
end
