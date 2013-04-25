# encoding: utf-8
class MessagesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    hookup = User.find(params[:user_id])
    first_message = Message.first_message(current_user, hookup)
    if first_message
      @message = first_message.replies.build(:to_user => hookup, :from_user => current_user, :message => params[:message][:message])
      @message.save
    else
      first_message = Message.new(:to_user => hookup, :from_user => current_user, :message => params[:message][:message])
      first_message.save
      first_message.thread_id = first_message.id
      first_message.save
      @messages = first_message
    end
    

    if params[:lite_version]
      @hookup = hookup

      render :thread
    else
      render :show
    end
  end

  def index
    hookup = User.find(params[:user_id])
    @messages = Message.thread(current_user, hookup)
  end

  def thread
    @hookup = User.find(params[:user_id])
    @messages = Message.thread(current_user, @hookup)
  end

end
