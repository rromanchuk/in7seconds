# encoding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:unsubscribe]
  respond_to :json, :html
  
  # DEPRECATED SOON TO BE DELETED
  def hookups
    @hookups = current_user.possible_hookups
    respond_with @hookups
  end

  # DEPRECATED SOON TO BE DELETED
  def matches
    @matches = current_user.hookups
    respond_with @matches
  end

  # DEPRECATED SOON TO BE DELETED
  def flirt
    hookup = User.find(params[:id])
    if current_user.is_requested?(hookup)
      User.fuck(current_user, hookup)
      @user = hookup
      render 'users/hookup_user'
      return
    else
      current_user.flirt(hookup)
    end
    render json: ''
  end

  # DEPRECATED SOON TO BE DELETED
  def reject
    @hookup = User.find(params[:id])
    current_user.reject(@hookup)
    render json: ''
  end

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

  # DEPRECATED SOON TO BE DELETED
  def authenticated_user
    @user = current_user
    respond_with @user
  end

  # DEPRECATED SOON TO BE DELETED
  def update_user
    @user = current_user
    @user.update_attributes(params[:user])
    render :authenticated_user
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