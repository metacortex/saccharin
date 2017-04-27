
macro json_value_to_i32(json, key, default = 0_i32)
  %c = {{ json.id }}[{{ key }}]?
  if %c
    if %c.as_s?
      %c.as_s.to_i32
    else
      %c.as_i
    end
  else
    {{ default }}
  end
end

macro json_value_to_i64(json, key, default = 0_i64)
  %c = {{ json.id }}[{{ key }}]?
  if %c
    if %c.as_s?
      %c.as_s.to_i64
    else
      %c.as_i64
    end
  else
    {{ default }}
  end
end
