class CreateAccountStatements < ActiveRecord::Migration[6.1]
  def change
    create_table :account_statements do |t|
      t.decimal :amount
      t.bigint :user_id

      t.timestamps
    end
    add_index :account_statements, :user_id, foreign_key: true 
  end
end
