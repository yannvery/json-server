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

  def add(name, params)
    find_or_create_collection(name)
    @data[name] << params.merge(id: next_id(name))
  end

  private

  def find_or_create_collection(name)
    collection(name) || @data[name] = []
  end

  def next_id(collection_name)
    return 1 if collection(collection_name).empty?
    collection(collection_name).map do |item|
      item["id"]
    end.max + 1
  end
end
