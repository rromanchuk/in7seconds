module Api
  module V1
    class NotificationsController < Api::BaseController
      before_filter :authenticate_user!
      respond_to :json
      
      def index
        @notifications = current_user.notifications
        respond_with @notifications
      end

      def mark_as_read
        @notifications = current_user.notifications
        @notifications.update_all(is_read: true)
        render json: ''
      end

    end
  end
end