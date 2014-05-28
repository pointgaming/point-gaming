module Streamable
  extend ActiveSupport::Concern

  included do
    before_filter :authenticate_user!
    before_filter :get_stream

    def get_stream
      @stream = Stream.find(params[:stream_id])

      unless @stream.collaborator?(current_user)
        redirect_to root_path, alert: "Access denied."
      end
    end
  end
end
