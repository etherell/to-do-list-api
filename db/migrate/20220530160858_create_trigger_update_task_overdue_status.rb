class CreateTriggerUpdateTaskOverdueStatus < ActiveRecord::Migration[6.1]
  def change
    create_trigger :update_task_overdue_status, on: :tasks
  end
end
