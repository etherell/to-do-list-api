class AddOverdueStatusToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :overdue_status, :integer
  end
end
