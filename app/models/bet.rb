class Bet < ApplicationRecord
    validates :result, inclusion: { in: %w(win loss) }, allow_nil: true 
  
    belongs_to :user
    
    has_many :bet_items
    has_many :events, :through => :bet_items
  
  end