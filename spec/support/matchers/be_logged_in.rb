require "rspec/expectations"

RSpec::Matchers.define :be_logged_in do
  match do |actual|
    expect(actual["warden.user.user.key"]).not_to be_nil
  end
  
  failure_message do
    "expected to be logged in"
  end
  
  failure_message_when_negated do
    "expected not to be logged in"
  end
  
  description do
    "check if session['warden.user.user.key'] is not nil"
  end
end