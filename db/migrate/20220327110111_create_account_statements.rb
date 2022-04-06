class CreateAccountStatements < ActiveRecord::Migration[6.1]
  def change
    create_table :account_statements do |t|
      t.decimal :amount

      t.timestamps
    end
    add_reference :account_statements, :user, foreign_key: true 
  end
end
