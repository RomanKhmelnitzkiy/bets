class UsersController < ApplicationController
  
  def index
    render :json => User.all
  end
    
  def new
    @users = User.all
  end

  def create
    if User.find_by(email: [:email]).nil?
      @user = User.new({email: params[:email], password: params[:password], role: "user", money: 0})
      if @user.save
        flash[:success] = "Добро пожаловать, #{@user.email}"
        redirect_to "/my-account/#{@user.id}"
      else
      end
    else
      flash[:success] = "Пользователь с таким email уже существует"
    end
  end
    
  def login
  end

  def login_post
    @user = User.find_by email: params[:email]
    if @user&.authenticate(params[:password])
      redirect_to "/user/my-account/#{@user.id}"
    else 
      redirect_to "/user/login"
    end
  end

  def logout

  end

  def account
    @account = User.find(params[:id])
  end
    
  def mybets
    @mybets = User.find(params[:id])
  end
  
  def statement
    @stat = User.find(params[:id]).account_statements
  end

  def deposit
    @user = User.find(params[:id]).bets
  end

  def make_deposit
    if @@User.role == "user"
      @@User.update!(money: @@User.money + params[:money].to_f)
      deposit = AccountStatement.create(amount: -params[:money], user_id: @@User.id)
      render :json => {"message": "Deposit is done"}
    end
  end
  
  def withdraw
    @user = User.find(params[:id])
  end

  def make_withdraw
    if @@User.role == "user"
      if @@User.money >= params[:money].to_f
        @@User.update!(money: @@User.money - params[:money].to_f)
        withdraw = AccountStatement.create(amount: +params[:money], user_id: @@User.id)
        render :json => {"message": "Withdraw is done"}
      else
        render :json => {"message": "You don't have enough money"}
      end
    end
  end
  
  end