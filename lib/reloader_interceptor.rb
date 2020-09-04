require "active_support"
require_relative "./reloader_interceptor/version"
require_relative "./reloader_interceptor/server_interceptor"
require_relative "./reloader_interceptor/wrapper"

module ReloaderInterceptor
  @enabled = true  # Enabled by default

  class << self
    # @return [bool]
    def enabled?
      @enabled
    end

    def enable!
      @enabled = true
    end

    def disable!
      @enabled = false
    end

    # @return [Class] A class which inherits ActiveSupport::Executor
    def executor
      reloader.executor
    end

    # @return [Class] A class which inherits ActiveSupport::Reloader
    def reloader
      @reloader ||= begin
        r = Class.new(ActiveSupport::Reloader)
        r.executor = Class.new(ActiveSupport::Executor)
        r
      end
    end

    attr_writer :enabled, :reloader
  end
end
