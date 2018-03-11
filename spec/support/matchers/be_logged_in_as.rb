module CustomMatchers
  class BeLoggedInAs
    def initialize
    end
    
    def matches?(user_session)
      user_session["warden.user.user.key"] != nil 
    end
    
    def failure_message
      "expected to be logged in"   
    end
    
    def failure_message_when_negated
      "expected not to be logged in"
    end
    
    def description
      "check if session['warden.user.user.key'] is not nil"
    end
  end
  
  def be_logged_in
    BeLoggedInAs.new
  end
end