# encoding: utf-8
class ImagesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    @image = Image.create!(params[:image])
    render json: ''
  end

end
