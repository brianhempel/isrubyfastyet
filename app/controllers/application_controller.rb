class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter { headers['Cache-Control'] = 'public'; headers['Expires'] = 1.day.from_now.httpdate } if Rails.env.production?
end
