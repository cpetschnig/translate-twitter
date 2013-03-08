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
end
