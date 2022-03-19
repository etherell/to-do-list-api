class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks, id: :uuid do |t|
      t.references :project, null: false, foreign_key: true, type: :uuid
      t.string :description, null: false

      t.timestamps
    end
  end
end
