# frozen_string_literal: true

class Project < ApplicationRecord
  include PgSearch::Model

  belongs_to :user
  has_many :tasks, dependent: :destroy
  has_many :archived_tasks, dependent: :destroy

  pg_search_scope :search_by_title, against: [:title],
                                    using: {
                                      tsearch: {
                                        prefix: true,
                                        tsvector_column: 'title_tsvector'
                                      }
                                    }
end
