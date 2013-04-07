# encoding: utf-8
class RelationshipsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

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

  def reject
    @hookup = User.find(params[:id]])
    User.reject(current_user, @hookup)
    render json: ''
  end

end
