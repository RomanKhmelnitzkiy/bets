class ApplicationController < ActionController::Base
  before_action :authorize

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
