class AddApitockenToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :apitoken, :string
  end
end
