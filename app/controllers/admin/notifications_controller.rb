module Admin
    
    class NotificationsController < BaseController
      before_filter :authenticate_user!
      respond_to :html

      def index
        @notifications = Notification.all
      end

      def new

      end
      
    end

end