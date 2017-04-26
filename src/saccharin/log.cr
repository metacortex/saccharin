require "file_utils"

module Saccharin
  module Logger
    class LogFile
      begin
        FileUtils.mkdir("log")
      rescue ex : Errno
      end

      INSTANCE = File.new("log/#{ENV["APP_ENV"]}.log", "a")

      def self.instance
        INSTANCE
      end
    end

    def _log(str)
      # STDIO
      puts str

      # file에 작성
      f = LogFile.instance
      f.puts str
      f.flush

      true
    end
  end
end

def _LOG(str)
  return if ENV["ENV"]? == "test"
  Saccharin::Logger::_log(str)
end

def _LOG_PROPS(props, padding : Int32 = 0)
  return if ENV["ENV"]? == "test"

  prefix = ""

  if padding > 0
    prefix = "%#{padding}s" % ""
  end

  props.each do |k,v|
    Saccharin::Logger::_log("#{prefix}#{k}: #{v}")
  end
end
