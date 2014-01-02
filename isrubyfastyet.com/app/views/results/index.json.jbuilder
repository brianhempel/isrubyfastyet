json.benchmark do
  json.(@benchmark, :name, :param, :units)
end
json.results @results, :time_str, :time_ms, :rvm_name, :result, :full_version
