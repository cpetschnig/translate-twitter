require "spec_helper"

describe TranslatedTweet do

  it { expect(subject).to be_a FormattedTweet }

  describe "associations" do
    it { expect(subject).to belong_to :tweet }
  end

  describe "validations" do
    it { expect(subject).to validate_length_of(:text).is_at_most(512) }
  end

  describe "mass assignment protection" do
    it { expect(subject).to allow_mass_assignment_of :text }
    it { expect(subject).to allow_mass_assignment_of :service_id }
  end

  describe "#repair_translation" do
    before do
      subject.tweet = Tweet.new(:text => "@nzkoz @steveklabnik @_dozen_ @_ko1 @n0kada.")
      subject.text = "@nzkoz @ steveklabnik @ _dozen _ @ _ko1 @ n 0kada."
    end

    it "should remove spaces in usernames" do
      subject.save
      expect(subject.text).to eq("@nzkoz @steveklabnik @_dozen_ @_ko1 @n0kada.")
    end
  end
end
