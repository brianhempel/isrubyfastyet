require 'tempfile'
require 'fileutils'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

# require all shared models
Dir[File.expand_path('../../shared_models/*.rb', __FILE__)].each { |f| require f }



RSpec.configure do |config|

end
