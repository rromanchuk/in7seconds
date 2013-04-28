# encoding: utf-8
class ImagesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    @image = current_user.images.build(params[:image])
    @image.save
    render json: ''
  end

end
