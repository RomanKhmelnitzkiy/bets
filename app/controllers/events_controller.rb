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
      
  def create
    
    if @@User.role == "admin"
      event = Event.create!({team1: params[:team1], team2: params[:team2],
        win_ratio_1: params[:win_ratio_1].to_f, win_ratio_2: params[:win_ratio_2].to_f, draw_ratio: params[:draw_ratio].to_f,
        dattime: params[:dattime], category: Category.find_by(alias: params[:category])})
      render :json => [{"message": "Event is created"}]
    else
      render :json => {"message": "You are not admin."}
    end
    
  end
    
  def update
    
    if @@User.role == "admin"
      event = Event.find_by(:id => params[:id])
      event.update!(result: params[:result])
      render :json => [{"message": "Result is #{event.result}"}]
    else
      render :json => {"message": "You are not admin."}
    end
        
  end

end
