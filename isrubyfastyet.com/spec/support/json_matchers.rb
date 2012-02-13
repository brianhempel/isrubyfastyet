RSpec::Matchers.define :be_json_like do |expected|
  match do |actual|
    JSON.parse(actual) == JSON.parse(expected)
  end
  failure_message_for_should do |actual|
    "expected #{actual} to be json like #{expected}"
  end
end