class UsersController < ApplicationController

  def index
    render :json => User.all
  end
    
  def new
    @user = User.new
  end

  def create
    if User.find_by(email: [:email]).blank?
      @user = User.new({email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation], role: "user", money: 0})
      if @user.save
        session[:user_id] = @user.id
        redirect_to "/my-account"
        flash[:alert] = "Добро пожаловать, #{current_user.email}."
      else
        flash[:success] = "Form is invalid"
        redirect_to "/user/new"
      end
    else
      redirect_to "/user/new"
      flash[:success] = "Пользователь с таким email уже существует."
    end
  end

  def account
    begin
      @account = current_user
      redirect_to "/" if @account.nil?
    rescue 
      redirect_to "/"
    end
  end
    
  def mybets
    begin
      @mybets = current_user.bets
      redirect_to "/" if @mybets.nil?
    rescue
      redirect_to "/"
    end
  end
  
  def statement
    begin
      @stat = current_user.account_statements
      redirect_to "/" if @stat.nil?
    rescue
      redirect_to "/"
    end
  end

  def deposit
    begin
      redirect_to "/" if current_user.nil?
    rescue 
      redirect_to "/"
    end
  end

  def make_deposit
    begin
      if current_user.role == "user"
        deposit = AccountStatement.create(amount: "-#{params[:money]}", user_id: current_user.id)
        current_user.update!(money: current_user.money + params[:money].to_f)
        redirect_to "/my-account"
        flash[:alert] = "Счет пополнен."
      elsif current_user.role == "admin"
        redirect_to "/my-account"
        flash[:alert] = "Админ не может пополнить счет."
      end
    rescue
      redirect_to "/"
      flash[:alert] = "Пожалуйста, войдите в аккаунт."
    end
  end
  
  def withdraw
    begin
      redirect_to "/" if current_user.nil?
    rescue 
      redirect_to "/"
    end
  end

  def make_withdraw
    begin
      if current_user.role == "user"
        if current_user.money >= params[:money].to_f
          withdraw = AccountStatement.create(amount: params[:money], user_id: current_user.id)
          current_user.update!(money: current_user.money - params[:money].to_f)
          redirect_to "/my-account"
          flash[:alert] = "Вывод средств выполнен."
        else
          redirect_to "/my-account"
          flash[:alert] = "У вас недостаточно средств."
        end
      elsif current_user.role == "admin"
        redirect_to "/my-account"
        flash[:alert] = "Админ не может вывести средства."
      end
    rescue
      redirect_to "/"
      flash[:alert] = "Пожалуйста, войдите в аккаунт."
    end
  end
  
  end