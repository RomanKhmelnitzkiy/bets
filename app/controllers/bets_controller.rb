class BetsController < ApplicationController

  def new_bet
    
  end

  def make_bet
    if @@User
      if @@User.role == "user"
        if @@User.money >= params[:bet_amount].to_f
  
          @bet = Bet.create!({user_id: @@User.id, bet_amount: params[:bet_amount]})
          
          i = 0
          while params[:event_id][i] and  params[:choise][i] do
            BetItem.create!({bet_id: @bet.id, event_id: params[:event_id][i], choise: params[:choise][i]})
            i += 1
          end
  
          i = 0
          @bet.ratio = 1
  
          while (params[:event_id][i] and params[:choise][i]) do
            @bet.ratio *= @bet.events[i].win_ratio_1 if @bet.bet_items[i].choise == "win1"
            @bet.ratio *= @bet.events[i].win_ratio_2 if @bet.bet_items[i].choise == "win2"
            @bet.ratio *= @bet.events[i].draw_ratio if @bet.bet_items[i].choise == "draw" 
            i += 1
          end
          
          @bet.save
          @@User.update!(money: @@User.money - params[:bet_amount].to_f)
          render :json => [{"message": "Bet is done"}, @bet]
        
        else
          render :json => {"message": "You don't have enough money to make bet"}   
        end
      end
    else
      render :json => {:message => "You are not authorized"}
    end
  end

end