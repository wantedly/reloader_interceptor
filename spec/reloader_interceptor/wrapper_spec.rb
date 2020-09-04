require "support/user_server"

RSpec.describe ReloaderInterceptor::Wrapper do
  describe ".wrap" do
    let(:src_class) {
      Support::UserServer
    }
    let(:src_obj) { double("Support::UserServer") }

    before do
      allow(src_class).to receive(:new).and_return(src_obj)
    end

    it "returns wrapped class" do
      dst_class = ReloaderInterceptor::Wrapper.wrap(src_class)
      expect(dst_class).to be_a ReloaderInterceptor::Wrapper::DSL

      # Test delegation of instance mthods
      expect(dst_class.public_instance_methods(false)).to eq [:get_user]
      expect(dst_class.protected_instance_methods(false)).to eq [:protected_method]
      expect(dst_class.private_instance_methods(false)).to include(:private_method)

      dst_obj = dst_class.new
      expect(src_obj).to receive(:get_user)
      dst_obj.get_user
      expect(src_obj).to receive(:protected_method)
      dst_obj.send(:protected_method)
      expect(src_obj).to receive(:private_method)
      dst_obj.send(:private_method)

      # Test delegation of singleton mthods
      dst_singleton_class = dst_class.singleton_class
      expect(dst_singleton_class.public_instance_methods(false)).to include(:public_singleton_method)
      expect(dst_singleton_class.protected_instance_methods(false)).to eq [:protected_singleton_method]
      expect(dst_singleton_class.private_instance_methods(false)).to eq [:private_singleton_method]

      expect(src_class).to receive(:public_singleton_method)
      dst_class.public_singleton_method
      expect(src_class).to receive(:protected_singleton_method)
      dst_class.send(:protected_singleton_method)
      expect(src_class).to receive(:private_singleton_method)
      dst_class.send(:private_singleton_method)

      # Test .name
      expect(dst_class.name).to eq src_class.name
    end
  end
end
