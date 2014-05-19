class StreamsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @streams = Stream.all
  end
end
