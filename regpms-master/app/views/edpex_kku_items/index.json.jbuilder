json.array!(@edpex_kku_items) do |edpex_kku_item|
  json.extract! edpex_kku_item, :id, :to_s, :edpex_kku_id, :no, :name, :target, :year1, :year2, :year3, :year4, :year5, :year, :institute
  json.url edpex_kku_item_url(edpex_kku_item, format: :json)
end