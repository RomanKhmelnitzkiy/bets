class BetsController < ApplicationController

  def index
    render :json => Bet.all
  end

  def items
    render :json => BetItem.all
  end
  
  def new
    
  end

  def make_bet
    if current_user.present?
      if current_user.role == "user"
        if current_user.money >= params[:bet_amount].to_f
  
          @bet = Bet.create!({user_id: current_user.id, bet_amount: params[:bet_amount]})
          
          i = 0
          while @cart[i] and params[:choise][i] do
            BetItem.create!({bet_id: @bet.id, event_id: @cart[i].id, choise: params[:choise][i]})
            i += 1
          end
  
          i = 0
          @bet.ratio = 1

          while (@cart[i] and params[:choise][i]) do
            @bet.ratio *= @bet.events[i].win_ratio_1 if @bet.bet_items[i].choise == "win1"
            @bet.ratio *= @bet.events[i].win_ratio_2 if @bet.bet_items[i].choise == "win2"
            @bet.ratio *= @bet.events[i].draw_ratio if @bet.bet_items[i].choise == "draw" 
            i += 1
          end
          
          @bet.save
          current_user.update!(money: current_user.money - params[:bet_amount].to_f)
          
          redirect_to "/my-account"
          flash[:alert] = "Ставка сделана."
          session[:cart] = []
        else
          redirect_to "/my-account"
          flash[:alert] = "У вас недостаточно средств."   
        end
      else
        redirect_to "/"
        flash[:alert] = "Админ не может ставить."
      end
    else
      redirect_to "/"
      flash[:alert] = "Пожалуйста, войдите в аккаунт."
    end
  end

end