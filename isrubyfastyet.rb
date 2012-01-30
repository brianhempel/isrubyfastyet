require 'rubygems'

def irfy_path(path)
  File.join(File.dirname(__FILE__), path)
end



$LOAD_PATH.unshift(irfy_path('shared_models'))

require 'ruby'
Ruby.rubies_file_path = irfy_path('runner/rubies')