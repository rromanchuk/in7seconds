module Api
  module V1
    
    class ImagesController < ApplicationController
      before_filter :authenticate_user!
      respond_to :json

      def create
        @image = current_user.images.build(params[:image])
        @image.provider = :phone
        @image.save
        @user = current_user.reload
        render 'api/v1/users/authenticate_user'
      end

    end
  end
end