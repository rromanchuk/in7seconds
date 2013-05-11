module Api
  module V1
    
    class RelationshipsController < ApplicationController
      before_filter :authenticate_user!
      respond_to :json

      def flirt
        hookup = User.find(params[:relationship][:hookup_id])
        if current_user.is_requested?(hookup)
          User.fuck(current_user, hookup)
          @user = hookup
          render 'api/v1/users/match_user'
          return
        else
          current_user.flirt(hookup)
        end
        render json: ''
      end

      def reject
        @hookup = User.find(params[:relationship][:hookup_id])
        current_user.reject(@hookup)
        render json: ''
      end
  
    end
  end
end