module Api
  module V1
    class NotificationsController < ApplicationController
      before_filter :authenticate_user!
      respond_to :json
      def index
        @notifications = current_user.notifications
        respond_with @notifications
      end
    end
  end
end