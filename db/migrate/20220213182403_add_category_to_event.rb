class AddCategoryToEvent < ActiveRecord::Migration[6.1]
  def change
    add_reference :events, :category, foreign_key: true
  end
end
