class SessionsController < ApplicationController

    def new
    end
  
    def create
      user = User.find_by email: params[:email]
      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to "/my-account"
        flash[:alert] = "Добро пожаловать, #{current_user.email}."
      else 
        redirect_to "/user/login"
        flash[:alert] = "Логин и/или пароль неверный."
      end
    end
  
    def destroy
      session.delete :user_id
      @current_user = nil
      flash[:alert] = "До скорой встречи!"
      redirect_to "/"
    end

end
