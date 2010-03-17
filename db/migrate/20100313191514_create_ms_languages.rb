class CreateMsLanguages < ActiveRecord::Migration
  def self.up
    create_table :ms_languages do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :ms_languages
  end
end
