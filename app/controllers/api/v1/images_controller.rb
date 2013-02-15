module Api
  module V1
    
    class ImagesController < Api::BaseController
      before_filter :authenticate_user!
      respond_to :json

      def create
        @image = current_user.images.build(params[:image])
        @image.provider = :phone
        @image.is_uploaded = true
        @image.save
        @user = current_user.reload
        render 'api/v1/users/authenticated_user'
      end

    end
  end
end