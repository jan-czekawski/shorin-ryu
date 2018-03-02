require 'rspec/expectations'

RSpec::Matchers.define :have_password_set_as do |password|
  match do |user| 
    expect(Devise::Encryptor.compare(User, user.encrypted_password, password)).to be true
  end

  failure_message do
    "User's new password expected to be #{password}"
  end

  failure_message_when_negated do
    "User's new password expected not to be #{password}"
  end

  description do
    "check if user's encrypted password holds same value as provided string"
  end
end