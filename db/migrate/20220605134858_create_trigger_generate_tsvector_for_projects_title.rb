class CreateTriggerGenerateTsvectorForProjectsTitle < ActiveRecord::Migration[6.1]
  def change
    create_trigger :generate_tsvector_for_projects_title, on: :projects
  end
end
