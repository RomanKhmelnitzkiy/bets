class RemoveDattimeFromBets < ActiveRecord::Migration[6.1]
  def change
    remove_column :bets, :dattime, :datetime
  end
end
