Dir.glob("#{File.dirname(__FILE__)}/config/*").each { |file| require_relative file }
Dir.glob("#{File.dirname(__FILE__)}/lib/*").each { |file| require_relative file }
