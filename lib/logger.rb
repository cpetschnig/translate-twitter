class Logger
  def self.info(msg)
    #write 'INFO', msg
  end
  def self.debug(msg)
    #write 'DEBUG', msg
  end
  def self.warn(msg)
    write 'WARN', msg
  end
  def self.error(msg)
    write 'ERROR', msg
  end
  def self.panic(msg)
    write 'PANIC', msg
  end
  private
  def self.write(type, msg)
    puts "#{Time.new.strftime('%Y-%m-%d %H:%M:%S')}: [#{type}] #{msg}"
  end
end