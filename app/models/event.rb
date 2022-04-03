class Event < ApplicationRecord
    validates :result, inclusion: { in: %w(win1 win2 draw) }, allow_nil: true
    validates :team1, :team2, :win_ratio_1, :win_ratio_2, :draw_ratio, :dattime, presence: true
    validates :win_ratio_1, :win_ratio_2, :draw_ratio, numericality: {greater_than: 1}
    validate :dattime_cannot_be_in_the_past
  
    belongs_to :category
    has_many :bet_items
    has_many :bets, :through => :bet_items
  
    after_update :set_bet_result
  
    def dattime_cannot_be_in_the_past
      if dattime < Time.now
        then errors.add(:dattime, "cannot be in the past")
      end
    end
  
    private
  
      def set_bet_result
  
        bet = Bet.all
  
        bet.each do |bet|
          j = 0
          n = nil
          res = "win"
          events = bet.events
          events.each do
          
            if bet.events[j].result
              then 
                if bet.events[j].result != bet.bet_items[j].choise
                  then res = "loss"
                  bet.update!(result: res)
                end
              else
                bet.result = nil
                bet.save
                n = 1
            end
  
            j += 1 
          end
  
            if n != 1
              then
              bet.update!(result: res)
              user = User.find_by(id: bet.user_id)
              user.update!(money: user.money + bet.bet_amount * bet.ratio) if bet.result == "win" and bet.events.find_by(id: self.id)
            end
        end
  
      end
  
  end