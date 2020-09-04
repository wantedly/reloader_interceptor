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
end
