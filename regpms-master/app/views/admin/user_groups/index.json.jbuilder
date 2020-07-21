json.array!(@user_groups) do |user_group|
  json.extract! user_group, :id, :to_s, :name, :roles_mask
  json.url admin_user_group_url(user_group, format: :json)
end