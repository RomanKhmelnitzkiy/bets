class BetItem < ApplicationRecord
    validates :choise, inclusion: { in: %w(win1 win2 draw) }
    
    belongs_to :bet
    belongs_to :event
    
  end