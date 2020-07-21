json.array!(@users) do |user|
  json.extract! user, :id, :username, :email, :role_names_join, :to_s
  json.url admin_user_url(user, format: :json)
end
