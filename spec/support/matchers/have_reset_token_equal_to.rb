module HaveResetTokenEqualTo
  class HaveResetTokenEqualTo
    def initialize(original_user_token)
      @original_user_token = original_user_token
    end
    
    def matches?(updated_user)
      @updated_user = updated_user
      @updated_user.reset_password_token == @original_user_token
    end
    
    def failure_message
      "#{@updated_user.reset_password_token} expected to be equal to #{@original_user_token}"
    end
    
    def failure_message_when_negated
      "#{@updated_user.reset_password_token} expected not to be equal to #{@original_user_token}"
    end
    
    def description
      "check if updated user's reset_password_token has changed"
    end
  end
  
  def have_reset_token_equal_to(token)
    HaveResetTokenEqualTo.new(token)
  end
end