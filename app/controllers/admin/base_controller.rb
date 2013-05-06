module Admin
  class BaseController < ApplicationController
    layout "admin"
    before_filter :authenticate_user!, :check_admin
    respond_to :html
    ADMINS = [41526347]

    def check_admin
      if ADMINS.include?(current_user.vkuid)

      else
        redirect_to root_path
        return
      end
    end
  end
end