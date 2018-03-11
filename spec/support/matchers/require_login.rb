module CustomMatchers
  class RequireLogin
    def initialize
    end
    
    def matches?(page_response)
      page_response.redirect_url == Rails.application.routes.url_helpers.new_user_session_url(host: "test.host")
    end
    
    def failure_message
      "expected to require login to access this method"
    end
    
    def failure_message_when_negated
      "expected not to require login to access this method"
    end
    
    def description
      "redirect to the login page"
    end
  end
  
  def require_login
    RequireLogin.new
  end
end