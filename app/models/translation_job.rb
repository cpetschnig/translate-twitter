class TranslationJob < ActiveRecord::Base

  belongs_to :source, :class_name => "TwitterAccount"
  belongs_to :target, :class_name => "TwitterAccount"

  validates :source_id, :presence => true

end
