# encoding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:unsubscribe]
  respond_to :json, :html

  def home
    # @feed_items = current_user.feed
    # respond_with @feed_items
  end

  def show
    @user = User.includes([:vk_country, :vk_city, :friends, :groups]).find(params[:id])
    render :hookup_user
  end

  def me
    @user = current_user
    render :show
  end

  def unsubscribe
    if user = User.read_access_token(params[:signature])
      user.update_attribute :email_opt_in, false
      render text: "Подписка отменена"
    else
      render text: "Неверная ссылка"
    end
  end

  def feed

  end

end