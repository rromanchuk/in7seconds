module Admin
  class BaseController < ApplicationController
    layout "admin"
    before_filter :authenticate_user!, :check_admin
    respond_to :html, :json

    ADMINS = [41526347, 2048071, 4807674, 54267159, 201331745]
    FB_ADMINS = [225311, 7300784, 1071841049, 759795370, 3421601]
    
    def check_admin
      if current_user && (ADMINS.include?(current_user.vkuid) or FB_ADMINS.include?(current_user.fbuid))

      else
        redirect_to root_path
        return
      end
    end
    
  end
end