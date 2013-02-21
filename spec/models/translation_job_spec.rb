require "spec_helper"

describe TranslationJob do

  describe "associations" do
    it { should belong_to :source }
    it { should belong_to :target }
  end

  describe "validations" do
    it { should validate_presence_of :source_id }
  end

end
