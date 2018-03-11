module CustomMatchers
  class HavePasswordSetAs
    def initialize(password)
      @password = password
    end
    
    def matches?(user)
      @user = user
      Devise::Encryptor.compare(User, @user.encrypted_password, @password)
    end
    
    def failure_message
      "User's new password expected to be #{@password}"
    end
    
    def failure_message_when_negated
      "User's new password expected not to be #{@password}"
    end
    
    def description
      "check if user's encrypted password holds same value as provided string"
    end
  end
  
  def have_password_set_as(pass)
    HavePasswordSetAs.new(pass)
  end
end