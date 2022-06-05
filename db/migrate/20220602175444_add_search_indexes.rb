class AddSearchIndexes < ActiveRecord::Migration[6.1]
  def up
    execute "ALTER TABLE projects ADD COLUMN title_tsvector tsvector;"
    execute "UPDATE projects SET title_tsvector = to_tsvector('english', coalesce(title,''))"
    execute "create index title_tsvector_idx on projects using gin(title_tsvector)"
  end

  def down
    execute 'ALTER TABLE projects DROP COLUMN title_tsvector'
  end
end
