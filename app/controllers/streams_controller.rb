class StreamsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @streams = Stream.all
  end

  def create
    @stream = Stream.new(new_stream_parameters)

    if @stream.save
      redirect_to @stream, notice: "Stream successfully created."
    else
      redirect_to streams_path, alert: "Stream could not be created."
    end
  end

  def validate_name
    @stream = Stream.new(new_stream_parameters)

    if @stream.valid?
      render json: true
    else
      render json: "Name is already taken."
    end
  end

  private
  def new_stream_parameters
    params.require(:stream).permit(:name, :avatar)
  end
end
