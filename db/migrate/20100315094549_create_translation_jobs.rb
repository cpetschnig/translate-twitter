class CreateTranslationJobs < ActiveRecord::Migration
  def self.up
    create_table :translation_jobs do |t|
      t.integer :source_id
      t.integer :target_id
      t.string :from_lang
      t.string :to_lang
      t.boolean :active
      t.timestamps
    end
  end

  def self.down
    drop_table :translation_jobs
  end
end
