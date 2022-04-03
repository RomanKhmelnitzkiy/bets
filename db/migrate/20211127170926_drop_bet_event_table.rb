class DropBetEventTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :bets_events
  end
end
