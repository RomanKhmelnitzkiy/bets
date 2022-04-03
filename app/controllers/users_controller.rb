class UsersController < ApplicationController
  
  def index
    render :json => User.all
  end
    
  def new
    @users = User.all
  end

  def create
    if User.find_by(email: [:email]).present?
      $User = User.new({email: params[:email], password: params[:password], role: "user", money: 0})
      if $User.save
        redirect_to "/my-account"
        flash[:alert] = "Добро пожаловать, #{$User.email}."
      else

      end
    else
      redirect_to "/user/new"
      flash[:success] = "Пользователь с таким email уже существует."
    end
  end
    
  def login
  end

  def login_post
    $User = User.find_by email: params[:email]
    if $User.nil?
      redirect_to "/user/login"
      flash[:alert] = "Логин и/или пароль неверный."
    else 
      redirect_to "/my-account"
      flash[:alert] = "Добро пожаловать, #{$User.email}."
    end
  end

  def logout
    $User = nil
    redirect_to "/"
  end

  def account
    begin
      @account = $User
      redirect_to "/" if @account.nil?
    rescue 
      redirect_to "/"
    end
  end
    
  def mybets
    begin
      @mybets = Bet.all.select {|as| as.user_id = $User.id}
      redirect_to "/" if @mybets.nil?
    rescue
      redirect_to "/"
    end
  end
  
  def statement
    begin
      @stat = AccountStatement.all.select {|as| as.user_id = $User.id} 
      redirect_to "/" if @stat.nil?
    rescue
      redirect_to "/"
    end
  end

  def deposit
    begin
      redirect_to "/" if $User.nil?
    rescue 
      redirect_to "/"
    end
  end

  def make_deposit
    begin
      if $User.role == "user"
        deposit = AccountStatement.create(amount: "-#{params[:money]}", user_id: $User.id)
        $User.update!(money: $User.money + params[:money].to_f)
        redirect_to "/my-account"
        flash[:alert] = "Счет пополнен."
      elsif $User.role == "admin"
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
      redirect_to "/" if $User.nil?
    rescue 
      redirect_to "/"
    end
  end

  def make_withdraw
    begin
      if $User.role == "user"
        if $User.money >= params[:money].to_f
          withdraw = AccountStatement.create(amount: +params[:money], user_id: $User.id)
          $User.update!(money: $User.money - params[:money].to_f)
          redirect_to "/my-account"
          flash[:alert] = "Вывод средств выполнен."
        else
          redirect_to "/my-account"
          flash[:alert] = "У вас недостаточно средств."
        end
      elsif $User.role == "admin"
        redirect_to "/my-account"
        flash[:alert] = "Админ не может вывести средства."
      end
    rescue
      redirect_to "/"
      flash[:alert] = "Пожалуйста, войдите в аккаунт."
    end
  end
  
  end