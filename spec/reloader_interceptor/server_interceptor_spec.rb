RSpec.describe ReloaderInterceptor::ServerInterceptor do
  class FakeReloader
    def initialize
      @reloaded = false
    end
    attr_reader :reloaded

    def wrap(&block)
      @reloaded = true
      yield
    end
  end

  subject {
    interceptor.request_response(
      request: double("request"),
      call:    double("call"),
      method:  double("method")) do
      response
    end
  }
  let(:interceptor) {
    ReloaderInterceptor::ServerInterceptor.new(
      reloader: reloader
    )
  }
  let(:reloader) { FakeReloader.new }
  let(:response) { double("response") }

  context "when ReloaderInterceptor is disabled" do
    before do
      allow(ReloaderInterceptor).to receive(:enabled?).and_return(false)
    end

    it "does not execute reloader.run!" do
      expect(subject).to eq response
      expect(reloader.reloaded).to eq false
    end
  end

  context "when ReloaderInterceptor is enabled" do
    before do
      allow(ReloaderInterceptor).to receive(:enabled?).and_return(true)
    end

    it "executes reloader.run!" do
      expect(subject).to eq response
      expect(reloader.reloaded).to eq true
    end
  end
end
