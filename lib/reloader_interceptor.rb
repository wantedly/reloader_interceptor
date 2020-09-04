require_relative "./reloader_interceptor/version"
require_relative "./reloader_interceptor/server_interceptor"
require_relative "./reloader_interceptor/wrapper"

module ReloaderInterceptor
  @enabled = true  # Enabled by default

  class << self
    def enabled?
      @enabled
    end

    def enable!
      @enabled = true
    end

    def disable!
      @enabled = false
    end

    attr_writer :enabled
  end
end
