class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter { headers['Cache-Control'] = "public, max-age=900" } if Rails.env.production?
end
