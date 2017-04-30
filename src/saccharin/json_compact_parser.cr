module Saccharin

  def self.parse_json_compact(c)
    h = Array(Hash(String, JSON::Type)).new
    cols = c["columns"].as_a
    rows = c["rows"].as_a

    # if rows.blank?
    #   rows.push([] of JSON::Type)
    # end

    rows.each do |row|
      row = row.as(Array)
      d = Hash(String, JSON::Type).new

      cols.each_with_index do |col, idx|
        if row[idx]?
          c = row[idx].not_nil!
          d[col.to_s] = parse_json_iteration_value(c)
        end
      end

      h.push(d)
    end

    h
  end

  def self.parse_json_iteration_value(c)
    if c.is_a? Array
      c.map do |k|
        parse_json_iteration_value(k).as(JSON::Type)
      end
    elsif c.is_a? Hash
      h = Hash(String, JSON::Type).new
      c.each do |k,v|
        h[k] = parse_json_iteration_value(k)
      end
      h
    elsif c.is_a? Bool
      c
    elsif c.is_a? Int64
      c
    elsif c.is_a? Float64
      c
    elsif c.is_a? String
      c
    else
      raise "invalid json type - #{c}, #{c.class}"
    end
  end

end
