class PidsController < ApplicationController
  def show
    render :text => Process.pid
  end
end