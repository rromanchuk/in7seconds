module Api
  module V1
    
    class ImagesController < ApplicationController
      before_filter :authenticate_user!
      respond_to :json

      def create
        @image = current_user.images.build(params[:image])
        @image.save
        @user = current_user.reload
        render 'users/authenticate_user'
      end

    end
  end
end