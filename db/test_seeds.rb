module TestSeeds
  SQL = <<-EOS
    INSERT INTO
      `twitter_accounts`
    VALUES
      (16,'yukihiro_matz',NULL,NULL,NULL,'2013-04-27 11:52:03','2013-04-27 11:52:03',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
  EOS

  def self.sow
    ActiveRecord::Base.connection.execute(SQL)
  end
end

TestSeeds.sow
