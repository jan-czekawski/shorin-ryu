module HaveSameEmailAs
  class HaveSameEmailAs
    def initialize(original_user)
      @original_user = original_user
    end
    
    def matches?(changed_user)
      @changed_user = changed_user
      @changed_user.email == @original_user.email
    end
    
    def failure_message
      "#{@original_user.email} expected to have the same email address"\
      " as #{@changed_user.email}"
    end
    
    def failure_message_when_negated
      "#{@original_user.email} expected not to have the same email address"\
      " as #{@changed_user.email}"
    end

    def description
      "check if user's email is updated"
    end
  end
  
  def have_same_email_as(user)
    HaveSameEmailAs.new(user)
  end
end