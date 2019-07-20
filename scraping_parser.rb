def images(raw_hash)
  raw_hash.map do |k, v|
    if k == 'floor_plan'
      { 'label': '間取り', 'url': v }
    elsif k == 'appearance'
      { 'label': '外観', 'url': v }
    else
      { 'label': 'その他', 'url': v }
    end
  end
end

def transportation(raw_hash)
  raw_hash['transportation'].each_slice(4).map { |arr| arr.join('') }
end
