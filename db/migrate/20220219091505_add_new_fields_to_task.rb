class AddNewFieldsToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :is_done, :boolean, default: false
    add_column :tasks, :deadline, :datetime, null: false
    add_column :tasks, :position, :integer
  end
end
