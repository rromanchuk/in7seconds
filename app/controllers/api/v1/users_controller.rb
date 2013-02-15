module Api
  module V1
    
    class UsersController < Api::BaseController
      before_filter :authenticate_user!, :except => [:unsubscribe]
      respond_to :json
      
      def hookups
        @hookups = current_user.possible_hookups
        respond_with @hookups
      end

      def matches
        @matches = current_user.hookups
        respond_with @matches
      end

      def mutual_friends
        match_user = User.find(params[:match_id])
        @mutual_friends = match_user.mutual_friends(current_user)
      end

      def flirt
        hookup = User.find(params[:id])
        if current_user.is_requested?(hookup)
          User.fuck(current_user, hookup)
          @user = current_user.hookups.where(id: hookup).first
          render 'api/v1/users/match_user'
          return
        else
          current_user.flirt(hookup)
        end
        render json: ''
      end

      def reject
        @hookup = User.find(params[:id])
        current_user.reject(@hookup)
        render json: ''
      end

      def show
        @user = User.includes([:vk_country, :vk_city, :friends, :groups]).find(params[:id])
        render :hookup_user
      end

      def authenticated_user
        @user = current_user
        respond_with @user
      end

      def update_user
        @user = current_user
        @user.update_attributes(params[:user])
        render :authenticated_user
      end
    end
  end
end