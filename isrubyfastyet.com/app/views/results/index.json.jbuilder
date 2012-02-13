json.benchmark do |json|
  json.(@benchmark, :name, :param, :units)
end
json.results @results, :time_str, :rvm_name, :result, :full_version

