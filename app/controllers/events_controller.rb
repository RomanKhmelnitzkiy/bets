class EventsController < ApplicationController
  def index
    @events = Event.all
  end
    
  def show
    Event.find_by(:id => params[:id])
  end
    
  def category
    @category = Category.find_by(alias: params[:category])
    @events = @category.events
    render 'index'
  end
      
  def new
    begin
      redirect_to "/" unless current_user.role == "admin"
      redirect_to "/" if current_user.nil?
    rescue 
      redirect_to "/"
    end
  end

  def create
    begin
      if current_user.role == "admin"
        event = Event.create!({team1: params[:team1], team2: params[:team2],
          win_ratio_1: params[:win_ratio_1].to_f, win_ratio_2: params[:win_ratio_2].to_f, draw_ratio: params[:draw_ratio].to_f,
          dattime: params[:dattime], category: Category.find_by(alias: params[:category])})
        redirect_to "/"
      elsif current_user.role == "user"
        redirect_to "/"
        flash[:alert] = "У вас нет прав администратора."
      end
    rescue
      redirect_to "/event/new"
      flash[:alert] = "Пожалуйста, проверьте правильность введенных данных."
    end
  end
    
  def update
    begin
      if current_user.role == "admin"
        event = Event.find_by(:id => params[:id])
        event.update!(result: params[:result])
        flash[:alert] = "Резельтат: #{event.result}"
      elsif current_user.role == "user"
        redirect_to "/"
        flash[:alert] = "У вас нет прав администратора."
      end
    rescue
      redirect_to "/"
      flash[:alert] = "Пожалуйста, проверьте правильность введенных данных.."
    end
  end

  def add_to_cart
    id = params[:id].to_i
    session[:cart] << id unless session[:cart].include?(id)
    redirect_back(fallback_location: root_path)
  end
  
  def remove_from_cart
    id = params[:id].to_i
    session[:cart].delete(id)
    redirect_back(fallback_location: root_path)
  end
  
end
