class ApplicationController < ActionController::Base
  before_action :authorize
  before_action :initialize_session
  before_action :load_cart


  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id].present? 
  end

  def user_signed_in?
    current_user.present?
  end

  def initialize_session
    session[:cart] ||= []
  end

  def load_cart
    @cart = Event.find(session[:cart])
  end

  helper_method :current_user, :user_signed_in?

  def authorize
    return false unless auth_headers
    case auth_headers[0] 
    when 'Basic'
      token = auth_headers[1]
      login, password = Base64.decode64(token).split(':')
      @@User = User.find_by(:email => login, :password => password)
    else
      false
    end
  end
  
  private
  
  def auth_headers
    return nil unless request.headers['Authorization'] 
    request.headers['Authorization'].split(' ')
  end
  
end
