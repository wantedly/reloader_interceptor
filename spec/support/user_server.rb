require "support/user_services_pb"

module Support
  class UserServer < UserService::Service
    class << self
      def public_singleton_method; end

    protected
      def protected_singleton_method; end

    private
      def private_singleton_method; end
    end

    def get_user(req, call)
      Google::Protobuf::Empty.new
    end

    protected
      def protected_method; end

    private
      def private_method; end
  end
end
