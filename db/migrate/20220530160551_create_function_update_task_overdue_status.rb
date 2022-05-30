class CreateFunctionUpdateTaskOverdueStatus < ActiveRecord::Migration[6.1]
  def change
    create_function :update_task_overdue_status
  end
end
