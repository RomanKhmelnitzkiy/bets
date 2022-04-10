class SessionsController < ApplicationController
  before_action :require_no_current_user, only: %i[new create]
  before_action :require_current_user, only: %i[destroy]

    def new
    end
  
    def create
      user = User.find_by email: params[:email]
      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        session[:cart] = []
        redirect_to "/my-account"
        flash[:alert] = "Добро пожаловать, #{current_user.email}."
      else 
        redirect_to "/user/login"
        flash[:alert] = "Логин и/или пароль неверный."
      end
    end
  
    def destroy
      session.delete :cart
      session.delete :user_id
      current_user = nil
      flash[:alert] = "До скорой встречи!"
      redirect_to "/"
    end

end
