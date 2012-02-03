RSpec::Matchers.define :be_json_like do |expected|
  match do |actual|
    JSON.parse(actual) == JSON.parse(expected)
  end
end