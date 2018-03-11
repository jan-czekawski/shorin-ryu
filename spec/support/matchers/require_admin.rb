module CustomMatchers
  class RequireAdmin
    def initialize
    end
    
    def matches?(page_response)
      page_response.redirect_url == Rails.application.routes.url_helpers.root_url(host: "test.host")
    end
    
    def failure_message
      "expected to require admin to access this method"
    end
    
    def failure_message_when_negated
      "expected not to require admin to access this method"
    end
    
    def description
      "redirect to the root page"
    end
  end
  
  def require_admin
    RequireAdmin.new
  end
end