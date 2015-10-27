require "spec_helper"
require_relative "../../lib/formatted_tweet"

describe FormattedTweet do

  class FormattedTweetModuleContainer
    include FormattedTweet
    attr_accessor :text
  end

  subject { FormattedTweetModuleContainer.new }

  describe "#formatted" do
    context "on http URLs" do
      it "should wrap URLs into <a> tags" do
        subject.text = "foo bar http://foo.bar"
        expect(subject.formatted).to eq(%|foo bar <a href="http://foo.bar">http://foo.bar</a>|)
      end
    end

    context "on https URLs" do
      it "should wrap URLs into <a> tags" do
        subject.text = "foo bar https://foo.bar"
        expect(subject.formatted).to eq(%|foo bar <a href="https://foo.bar">https://foo.bar</a>|)
      end
    end
  end
end
