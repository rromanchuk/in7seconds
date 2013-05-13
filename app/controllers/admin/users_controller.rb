module Admin
    
    class UsersController < BaseController
      before_filter :authenticate_user!
      respond_to :html

      def index
        @users = User.active
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