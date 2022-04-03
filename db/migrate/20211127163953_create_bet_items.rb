class CreateBetItems < ActiveRecord::Migration[6.1]
  def change
    create_table :bet_items do |t|
      t.string :choise
      t.bigint "bet_id", null: false
      t.bigint "event_id", null: false

      t.timestamps
    end
    add_index :bet_items, :bet_id
    add_index :bet_items, :event_id
  end
end
