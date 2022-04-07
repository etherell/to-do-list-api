class CreateArchivedTasks < ActiveRecord::Migration[6.1]
  def change
    create_view :archived_tasks
  end
end
