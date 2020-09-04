require "active_support/core_ext"

module ReloaderInterceptor
  class Wrapper
    module DSL
      # @param [Class] dst Wrapping class
      # @param [String] src Wrapped class
      def define_singleton_methods_using_class_name(dst, src)
        src_name = src.name

        src_singleton_class = src.singleton_class
        dst_singleton_class = dst.singleton_class

        public_methods    = src_singleton_class.public_instance_methods(false)
        protected_methods = src_singleton_class.protected_instance_methods(false)
        private_methods   = src_singleton_class.private_instance_methods(false)

        [*public_methods, *protected_methods, *private_methods].each do |method|
          dst_singleton_class.define_method method do |*args|
            klass = src_name.constantize
            klass.send(method, *args)
          end
        end

        dst_singleton_class.send(:protected, *protected_methods) if protected_methods.size > 0
        dst_singleton_class.send(:private,   *private_methods)   if private_methods.size > 0
      end

      # @param [Class] dst Wrapping class
      # @param [String] src Wrapped class
      def define_instance_methods_using_class_name(dst, src)
        src_name = src.name

        public_methods    = src.public_instance_methods(false)
        protected_methods = src.protected_instance_methods(false)
        private_methods   = src.private_instance_methods(false)

        [*public_methods, *protected_methods, *private_methods].each do |method|
          dst.define_method method do |*args|
            klass = src_name.constantize
            klass.new(*@options).send(method, *args)
          end
        end

        dst.send(:protected, *protected_methods) if protected_methods.size > 0
        dst.send(:private,   *private_methods)   if private_methods.size > 0
      end
    end

    class << self
      # @param [Class] klass An original class.
      # @return [Class] A wrapping class. Return the original one if
      #     `ReloaderInterceptor` is disabled.
      def wrap(klass)
        return klass unless ReloaderInterceptor.enabled?

        klass_name = klass.name
        Class.new(klass.superclass) do
          extend Wrapper::DSL

          # Define `.name` and `.inspect` to mimic the original class.
          self.define_singleton_method :name do
            klass_name
          end
          self.define_singleton_method :inspect do
            klass_name
          end

          def initialize(*options)
            @options = options
          end

          define_instance_methods_using_class_name(self, klass)
          define_singleton_methods_using_class_name(self, klass)
        end
      end
    end
  end
end
