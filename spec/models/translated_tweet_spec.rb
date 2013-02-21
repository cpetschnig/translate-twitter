require "spec_helper"

describe TranslatedTweet do

  describe "associations" do
    it { should belong_to :tweet }
  end

  describe "validations" do
    it { should ensure_length_of(:text).is_at_most(512) }
  end

end
