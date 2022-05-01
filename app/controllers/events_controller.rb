class EventsController < ApplicationController
  def index
    @events = Event.all.where(dattime: (Time.now.midnight)..Time.now.midnight + 30.day).order(dattime: :asc)
  end
    
  def show
    Event.find_by(:id => params[:id])
  end

  def search
    @events = Event.where("team1 ILIKE ?", "%" + params[:q] + "%").or(Event.where("team2 ILIKE ?", "%" + params[:q] + "%"))
    render 'index'
  end
    
  def category
    @category = Category.find_by(alias: params[:category])
    @events = @category.events.where(dattime: (Time.now.midnight)..Time.now.midnight + 30.day).order(dattime: :asc)
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
      if params[:dattime] < Time.now
        flash[:alert] = "Нельзя создать событие которое уже началось."
        redirect_back(fallback_location: root_path)
        return
      end
      if current_user.role == "admin"
        event = Event.create!({team1: params[:team1], team2: params[:team2],
          win_ratio_1: params[:win_ratio_1].to_f, win_ratio_2: params[:win_ratio_2].to_f, draw_ratio: params[:draw_ratio].to_f,
          dattime: params[:dattime], category: Category.find_by(alias: params[:category])})
        redirect_to "/"
        flash[:alert] = "Событие успешно создано!"
      elsif current_user.role == "user"
        redirect_to "/"
        flash[:alert] = "У вас нет прав администратора."
      end
    rescue
      redirect_to "/event/new"
      flash[:alert] = "Пожалуйста, проверьте правильность введенных данных."
    end
  end
    
  def up
    @event = Event.find(params[:id])
  end

  def update
    begin
      if current_user.role == "admin"
        @event = Event.find(params[:id])
        @event.update!(result: params[:result])
        redirect_to "/"
        flash[:alert] = "Резельтат: #{@event.result}"
      elsif current_user.role == "user"
        redirect_to "/"
        flash[:alert] = "У вас нет прав администратора."
      end
    rescue
      redirect_to "/"
      flash[:alert] = "Пожалуйста, проверьте правильность введенных данных."
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
  
  def create_via_upload
    if current_user.role == "admin"
      if params[:file].nil?
        flash[:alert] = "Загрузите файл."
        redirect_back(fallback_location: root_path)
        return
      end 
      if params[:file].content_type != "application/json" 
        flash[:alert] = "Файл должен быть формата JSON."
        redirect_back(fallback_location: root_path)
        return
      end

      file = File.open(params[:file], "r+")
      if file.size == 0
        flash[:alert] = "Файл пустой."
        redirect_back(fallback_location: root_path)
        return
      end
      
      begin
      events = JSON.parse(file.read)
      file.close
      rescue
        flash[:alert] = "Содержимое файла не валидно."
        redirect_back(fallback_location: root_path)
        return
      end

      events.each do |event|
        begin
          next if params[:dattime] < Time.now
        Event.create!({team1: event["team1"], team2: event["team2"],
          win_ratio_1: event["win_ratio_1"].to_f, win_ratio_2: event["win_ratio_2"].to_f, draw_ratio: event["draw_ratio"].to_f,
          dattime: event["dattime"], category: Category.find_by(id: event["category_id"])})
        rescue
          flash[:alert] = "Содержимое файла не валидно."
          redirect_back(fallback_location: root_path)
          return
        end
      end

      flash[:alert] = "Файл успешно загружен."
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  def download_json
    if current_user.role == "admin"
      file = File.new("events_all.json", "w+")
      file.print(Event.all.to_json)
      file.close
      send_file "events_all.json", :type => 'application/json'
    else
      redirect_to "/"
    end
  end

end
