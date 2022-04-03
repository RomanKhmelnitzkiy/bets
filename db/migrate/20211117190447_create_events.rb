class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :team1
      t.string :team2
      t.decimal :win_ratio_1
      t.decimal :win_ratio_2
      t.decimal :draw_ratio
      t.datetime :dattime
      t.string :result

      t.timestamps
    end
  end
end
