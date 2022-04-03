class CreateBets < ActiveRecord::Migration[6.1]
  def change
    create_table :bets do |t|
      t.decimal :ratio
      t.decimal :bet_amount
      t.datetime :dattime
      t.string :result

      t.timestamps
    end
  end
end
