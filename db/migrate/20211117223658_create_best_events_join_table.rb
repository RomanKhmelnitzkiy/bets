class CreateBestEventsJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :bets, :events do |t|
      t.index :bet_id
      t.index :event_id
    end
  end
end
