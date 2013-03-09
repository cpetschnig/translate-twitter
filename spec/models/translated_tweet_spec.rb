require "spec_helper"

describe TranslatedTweet do

  describe "associations" do
    it { should belong_to :tweet }
  end

  describe "validations" do
    it { should ensure_length_of(:text).is_at_most(512) }
  end

  describe "mass assignment protection" do
    it { should allow_mass_assignment_of :text }
    it { should allow_mass_assignment_of :service_id }
  end

  describe "#repair_translation" do
    before do
      subject.tweet = Tweet.new(:text => "@nzkoz @steveklabnik @_dozen_ @_ko1 @n0kada.")
      subject.text = "@nzkoz @ steveklabnik @ _dozen _ @ _ko1 @ n 0kada."
    end

    it "should remove spaces in usernames" do
      subject.save
      subject.text.should == "@nzkoz @steveklabnik @_dozen_ @_ko1 @n0kada."
    end
  end
end
