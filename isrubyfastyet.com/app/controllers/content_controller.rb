class ContentController < ApplicationController

  def home
  end

  def latest_log
    render 'latest.log', :layout => false
    headers['Content-Type'] = 'text/plain'
  end

end