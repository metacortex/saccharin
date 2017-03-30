module Saccharin
  module DigMethods
    def dig?(keys : Enumerable)
      _hash = dup
      
      keys.each do |key|
        begin
          _hash = _hash[key]?
        rescue
          return nil
        end
        
        return nil if _hash.nil?
      end
      
      _hash
    end
    
    def dig(keys : Enumerable)
      _hash = dup
      
      keys.each do |key|
        _hash = _hash[key]
      end
      
      _hash
    end
    
    def dig_present?(keys : Enumerable) : Bool
      c = dig?(keys)
      
      if c && c.present?
        true
      else
        false
      end
    end
    
    def dig_blank?(keys : Enumerable) : Bool
      c = dig?(keys)
      
      if c && !c.blank?
        false
      else
        true
      end
    end
    
    def dig_empty?(keys : Enumerable) : Bool
      dig_blank?(keys)
    end
  end
end

struct JSON::Any
  include Saccharin::DigMethods
end

struct YAML::Any
  include Saccharin::DigMethods
end
