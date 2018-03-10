# require 'rspec/expectations'

# RSpec::Matchers.define :require_admin do
#   match do |actual|
#     expect(actual).to redirect_to \
#       Rails.application.routes.url_helpers.root_path
#   end

#   failure_message do
#     "expected to require admin to access this method"
#   end

#   failure_message_when_negated do
#     "expected not to require admin to access this method"
#   end

#   description do
#     "redirect to the root page"
#   end
# end

module RequireAdmin
  class RequireAdmin
    def initialize
    end
    
    def matches?(page_response)
      p page_response.redirect_url, Rails.application.routes.url_helpers.root_path
      page_response.redirect_url == Rails.application.routes.url_helpers.root_path
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