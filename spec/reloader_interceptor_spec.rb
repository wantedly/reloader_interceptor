RSpec.describe ReloaderInterceptor do
  it "has a version number" do
    expect(ReloaderInterceptor::VERSION).not_to be nil
  end

  describe ".enabled?" do
    after(:all) { ReloaderInterceptor.enable! }  # Reset state

    it "returns true" do
      expect(ReloaderInterceptor.enabled?).to eq true
    end

    context "when disabled or enabled" do
      it "returns the flag" do
        ReloaderInterceptor.disable!
        expect(ReloaderInterceptor.enabled?).to eq false
        ReloaderInterceptor.enable!
        expect(ReloaderInterceptor.enabled?).to eq true
        ReloaderInterceptor.enabled = false
        expect(ReloaderInterceptor.enabled?).to eq false
      end
    end
  end

  describe ".reloader" do
    it "returns a class which inherits ActiveSupport::Reloader" do
      expect(ReloaderInterceptor.reloader).to be_a Class
      expect(ReloaderInterceptor.reloader.superclass).to eq ActiveSupport::Reloader
    end

    context "when a reloader is set" do
      before do
        ReloaderInterceptor.reloader = reloader
      end

      after do
        ReloaderInterceptor.reloader = nil  # Cleanup
      end

      let(:reloader) { double("ActiveSupport::Reloader") }

      it "return a set reloader" do
        expect(ReloaderInterceptor.reloader).to eq reloader
      end
    end
  end

  describe ".executor" do
    it "returns a executor" do
      expect(ReloaderInterceptor.executor).to be_a Class
      expect(ReloaderInterceptor.executor.superclass).to eq ActiveSupport::Executor
      expect(ReloaderInterceptor.executor).to eq ReloaderInterceptor.reloader.executor
    end
  end
end
