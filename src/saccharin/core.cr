
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
