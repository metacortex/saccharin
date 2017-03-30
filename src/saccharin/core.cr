require "json"
require "yaml"

# == Core extensions
# 
# ++present?++, ++blank?++
# 
module Saccharin
  module PresentAndBlankBySize
    def present?
      size > 0
    end
    
    def blank?
      size == 0
    end
  end
  
  module PresentAndBlankForAny
    def present?
      begin
        size > 0
      rescue
        raw.present?
      end
    end
    
    def blank?
      begin
        size == 0
      rescue
        raw.blank?
      end
    end
  end
  
  module PresentAndBlankForValue
    def present?
      true
    end
    
    def blank?
      false
    end
  end
  
  module PresentAndBlankForNil
    def present?
      false
    end
    
    def blank?
      true
    end
  end
end

module Enumerable(T)
  include Saccharin::PresentAndBlankBySize
end

struct JSON::Any
  include Saccharin::PresentAndBlankForAny
end

struct YAML::Any
  include Saccharin::PresentAndBlankForAny
end

struct NamedTuple
  include Saccharin::PresentAndBlankBySize
end

class String
  include Saccharin::PresentAndBlankBySize
end

struct Int
  include Saccharin::PresentAndBlankForValue
end

struct Float
  include Saccharin::PresentAndBlankForValue
end

struct Time
  include Saccharin::PresentAndBlankForValue
end

struct Nil
  include Saccharin::PresentAndBlankForNil
end

struct Bool
  def present?
    self
  end
  
  def blank?
    !self
  end
end
