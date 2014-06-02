class StreamsController < ApplicationController
  include Tubesock::Hijack
  before_filter :authenticate_user!

  def index
    @streams = Stream.all
  end

  def show
    @stream = Stream.find(params[:id])
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
    @stream.valid?

    if Stream.any_of({ name: @stream.name }, { slug: @stream.slug }).exists?
      render json: '"Name is already taken."'
    else
      render json: true
    end
  end

  private
  def new_stream_parameters
    params.require(:stream).permit(:name, :avatar, :channel_source, :channel_name, :description)
  end
end
