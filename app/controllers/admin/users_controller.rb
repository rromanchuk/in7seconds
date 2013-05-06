module Admin
    
    class UsersController < BaseController
      before_filter :authenticate_user!
      respond_to :html

      def index
        @users = User.active
      end

    end
end