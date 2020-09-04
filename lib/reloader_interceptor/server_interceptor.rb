require "grpc"

module ReloaderInterceptor
  class ServerInterceptor < GRPC::ServerInterceptor
    def initialize(reloader:)
      @reloader = reloader
    end

    def request_response(request:, call:, method:, &block)
      return yield unless ReloaderInterceptor.enabled?

      @reloader.wrap do
        yield
      end
    end

    # NOTE: For now, we don't support server_streamer, client_streamer and bidi_streamer
  end
end
