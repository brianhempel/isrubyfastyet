require 'rubygems'

def irfy_path(path)
  File.join(File.dirname(__FILE__), path)
end

$LOAD_PATH.unshift(irfy_path('runner'))
$LOAD_PATH.unshift(irfy_path('.'))
