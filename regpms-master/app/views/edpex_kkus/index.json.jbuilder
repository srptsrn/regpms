json.array!(@edpex_kkus) do |edpex_kku|
  json.extract! edpex_kku, :id, :to_s, :year, :edpex_kku_group_id, :no, :name, :description
  json.url edpex_kku_url(edpex_kku, format: :json)
end