class JsonParser
  def initialize(file)
    file = File.read('db.json')
    @data = JSON.parse(file)
  end

  def collection(name = nil)
    return @data if name.empty?
    @data[name]
  end

  def select(name, params)
    collection(name).select do |item|
      params.map do |key, value|
        item[key].to_s == value.to_s
      end.reduce(:&)
    end
  end
end
