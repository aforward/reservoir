# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'rubygems'
require 'rspec'
require File.dirname(__FILE__) + '/../lib/reservoir'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
# Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|

  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec
  # config.before(:each) { Machinist.reset_before_test }
  
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

end


def stub_version(script_name,outputs = [])
  outputs = [ outputs ] if outputs.kind_of?(String)
  
  Reservoir::Caller.stub!(:exec).with("#{script_name} --version").and_return(outputs[0] || "")
  Reservoir::Caller.stub!(:exec).with("#{script_name} -version").and_return(outputs[1] || "")
  Reservoir::Caller.stub!(:exec).with("npm view #{script_name} | grep version:").and_return(outputs[2] || "")
end
