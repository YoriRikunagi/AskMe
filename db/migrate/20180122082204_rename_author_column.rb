class RenameAuthorColumn < ActiveRecord::Migration
  def change
    rename_column :questions, :author, :author_id
  end
end
