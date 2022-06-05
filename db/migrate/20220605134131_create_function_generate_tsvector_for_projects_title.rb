class CreateFunctionGenerateTsvectorForProjectsTitle < ActiveRecord::Migration[6.1]
  def change
    create_function :generate_tsvector_for_projects_title
  end
end
