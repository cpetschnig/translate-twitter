class CreateTweetTranslations < ActiveRecord::Migration
  def self.up
    create_table :tweet_translations do |t|
      t.integer :tweet_id
      t.integer :service_id
      t.string :text

      t.timestamps
    end
  end

  def self.down
    drop_table :tweet_translations
  end
end
