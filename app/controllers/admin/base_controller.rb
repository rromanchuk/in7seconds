module Admin
  class BaseController < ApplicationController
    layout "admin"
    before_filter :authenticate_user!, :check_admin
    respond_to :html, :json

    def check_admin
      if current_user.try(:admin?)
        
      else
        redirect_to root_path
        return
      end
    end
    
  end
end