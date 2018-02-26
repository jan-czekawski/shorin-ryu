require 'rspec/expectations'

RSpec::Matchers.define :require_admin do |expected|
  match do |actual|
    expect(actual).to redirect_to \
      Rails.application.routes.url_helpers.root_path
  end
  
  failure_message do |actual|
    "expected to require admin to access this method"
  end
  
  failure_message_when_negated do |actual|
    "expected not to require admin to access this method"
  end
  
  description do
    "redirect to the root page"
  end
end