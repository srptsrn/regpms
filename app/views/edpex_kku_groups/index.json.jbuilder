json.array!(@edpex_kku_groups) do |edpex_kku_group|
  json.extract! edpex_kku_group, :id, :to_s, :no, :name
  json.url edpex_kku_group_url(edpex_kku_group, format: :json)
end