class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: {unique: true}
      t.string :password_digest
      t.decimal :money
      t.string :role

      t.timestamps
    end
  end
end
