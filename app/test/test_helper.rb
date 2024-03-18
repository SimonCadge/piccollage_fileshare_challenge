ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end

  class ActionDispatch::IntegrationTest
    def log_in_as(user, password)
      post session_path, params: { email: user.email, password: password, password_confirmation: password}
    end
    
    def log_out
      delete session_path
    end
  end
end
