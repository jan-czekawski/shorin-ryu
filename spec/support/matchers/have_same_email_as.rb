require 'rspec/expectations'

RSpec::Matchers.define :have_same_email_as do |matched|
  match do |actual| 
    expect(actual.email).to eq matched.email
  end

  failure_message do
    "#{matched.email} expected to have the same email address as #{actual.email}"
  end

  failure_message_when_negated do
    "#{matched.email} expected not to have the same email address as #{actual.email}"
  end

  description do
    "check if user's email is updated"
  end
end