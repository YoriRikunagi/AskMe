class AddAuthorColumnToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :author, :integer
  end
end
