# encoding: utf-8
# DEPRECATED SOON TO BE DELETED
class RelationshipsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  # DEPRECATED SOON TO BE DELETED
  def flirt
    hookup = User.find(params[:relationship][:hookup_id])
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
    @hookup = User.find(params[:relationship][:hookup_id])
    current_user.reject(@hookup)
    render json: ''
  end
  
end
