def madori(str)
  room_detail = str.slice!(/\(.+?\)/)
  madori =
    case str
    when /^([0-9])?([LDKR]+?)\+[0-9]?(S)$/
      { num_rooms: $1 ? $1.to_i : 1, room_type: $3 + $2 }
    when /^([0-9]+)?([SLDKR]+)/
      { num_rooms: $1 ? $1.to_i : 1, room_type: $2 }
    end
  madori[:room_detail] = room_detail unless madori.nil?
  madori
end

def square(str)
  return nil unless str.is_a?(String)
  str = str.strip
  str = str&.gsub(/\(.*\)/, '')
  case str
  when /([0-9|.]+)㎡/
    $1.to_f
  when /([0-9|.]+)m²/
    $1.to_f
  when /([0-9|.]+)m/
    $1.to_f
  end
end

def completion(str)
  case str.strip
  when /(\d{4})年\s*(\d+)月/
    { completion: "#{$1}#{'%02d' % $2.to_i}", newness_status: :used }
  when /築(\d+)年/
    year = Date.today.year - $1.to_i
    { completion: Date.today.strftime("#{year}00"), newness_status: :used }
  end
end
