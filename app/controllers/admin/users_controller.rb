module Admin
    
    class UsersController < BaseController
      before_filter :authenticate_user!
      respond_to :html

      def index
        @users = User.active
      end

      def stats
        @total_users = User.active.count
        @total_users_yesterday = User.added_yesterday.count
        @toal_ratings = Relationship.count
        @total_matches = Relationship.matches_yesterday.count
        @percent_female = User.active.women.length.to_f / User.active.length.to_f

        @total_ratings_yesterday = Relationship.added_yesterday.count
        @users_with_geo_location = User.with_geo_location.count
        @names_yesterday = User.active.added_yesterday.map(&:name).join(", ")
        @names = User.active.map(&:name).join(", ")
      end

      def show
        @user = User.find(params[:id])
      end

      def flirt
        session[:return_to] ||= request.referer
        hookup = User.find(params[:id])
        if current_user.is_requested?(hookup)
          User.fuck(current_user, hookup)
          @user = hookup
        else
          current_user.flirt(hookup)
        end
        
        redirect_to session[:return_to]
      end

      def send_notification
        session[:return_to] ||= request.referer
        hookup = User.find(params[:id])
        Notification.custom(hookup, params[:message])
        respond_with true
      end

      def send_pending_reminder
        session[:return_to] ||= request.referer
        hookup = User.find(params[:id])
        requested = hookup.requested_hookups
        unless requested.blank?
          Notification.notify_requested_hookups(hookup)
          Mailer.delay.pending_requests(hookup)
        end

        redirect_to session[:return_to]
      end

    end
end