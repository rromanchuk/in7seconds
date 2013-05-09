module Admin
    
  class RelationshipsController < ApplicationController
    before_filter :authenticate_user!
    respond_to :json

    def flirt
      session[:return_to] ||= request.referer
      hookup = User.find(params[:id])
      if current_user.is_requested?(hookup)
        User.fuck(current_user, hookup)
        @user = hookup
        render 'api/v1/users/match_user'
        return
      else
        current_user.flirt(hookup)
      end
      
      redirect_to session[:return_to]
    end

    def reject
      session[:return_to] ||= request.referer
      @hookup = User.find(params[:id])
      current_user.reject(@hookup)
      
      redirect_to session[:return_to]
    end

  end
end