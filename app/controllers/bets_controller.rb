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
    if params[:bet_amount].to_f > 10000 || params[:bet_amount].to_f < 1
      flash[:alert] = "Ограничение на ставку: от 1 до 10000."
      redirect_back(fallback_location: root_path)
      return
    end

    @cart.each do |el|
      if el.dattime < Time.now
        flash[:alert] = "Нельзя поставить на событие, которое уже началось."
        redirect_back(fallback_location: root_path)
        return
      end
    end

    if current_user.present?
      if current_user.role == "user"
        if current_user.money >= params[:bet_amount].to_f

          params[:choise].each do |el|
            if el == "Выберите"
              flash[:alert] = "Пожалуйста, выберитие исход."
              redirect_back(fallback_location: root_path)
              return
            end
          end

          @bet = Bet.create!({user_id: current_user.id, bet_amount: params[:bet_amount]})
          
          i = 0
          while @cart[i] and params[:choise][i] do
            BetItem.create!({bet_id: @bet.id, event_id: @cart[i].id, choise: params[:choise][i]})
            i += 1
          end
  
          i = 0
          @bet.ratio = 1

          while (@cart[i] and params[:choise][i]) do
            @bet.ratio *= @cart[i].win_ratio_1 if @bet.bet_items[i].choise == "win1"
            @bet.ratio *= @cart[i].win_ratio_2 if @bet.bet_items[i].choise == "win2"
            @bet.ratio *= @cart[i].draw_ratio if @bet.bet_items[i].choise == "draw" 
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