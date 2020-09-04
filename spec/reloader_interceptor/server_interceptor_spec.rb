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
  let(:response) { double("response") }

  context "when reloader is set" do
    let(:interceptor) {
      ReloaderInterceptor::ServerInterceptor.new(
        reloader: reloader
      )
    }
    let(:reloader) { FakeReloader.new }

    context "when ReloaderInterceptor is disabled" do
      before do
        allow(ReloaderInterceptor).to receive(:enabled?).and_return(false)
      end

      it "does not execute reloader" do
        expect(subject).to eq response
        expect(reloader.reloaded).to eq false
      end
    end

    context "when ReloaderInterceptor is enabled" do
      before do
        allow(ReloaderInterceptor).to receive(:enabled?).and_return(true)
      end

      it "executes reloader" do
        expect(subject).to eq response
        expect(reloader.reloaded).to eq true
      end
    end
  end

  context "when reloader is not set" do
    let(:interceptor) {
      ReloaderInterceptor::ServerInterceptor.new
    }
    let(:reloader) { FakeReloader.new }

    it "uses ReloaderInterceptor.reloader" do
      expect(ReloaderInterceptor).to receive(:reloader).and_return(reloader)

      expect(subject).to eq response
      expect(reloader.reloaded).to eq true
    end
  end
end
