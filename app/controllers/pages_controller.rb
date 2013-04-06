# encoding: utf-8
class PagesController < ApplicationController

  respond_to :json, :html
  
  def sandbox

  end

  def about

  end

  def feed
    render 'generic'
  end

  def tos

  end

  def index
    if current_user
      redirect_to feed_path
      return
    else
      render :layout => "splash"
      return
    end
  end

  def error_404
    @not_found_path = params[:not_found]
    # render :layout => "splash"
  end

  def error_500
    # render :layout => "splash"
  end

end
