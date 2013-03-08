# encoding: utf-8
class MessagesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

end
