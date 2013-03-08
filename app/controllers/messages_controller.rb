# encoding: utf-8
class MessagesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    @hookup = User.find(params[:user_id])
    last_message = Message.where('(from_user_id = ? AND to_user_id = ?) OR (to_user_id = ? AND from_user_id = ?)', @hookup.id, current_user.id, current_user.id, @hookup.id)
    if last_message
      @message = last_message.replies.build(:to_user => @hookup, :from_user => current_user, :body => params[:message][:message])
    else
      @message = Message.new(:to_user => @hookup, :from_user => current_user, :message => params[:message][:message])

    end
    render :show
  end

  def index

  end


end
