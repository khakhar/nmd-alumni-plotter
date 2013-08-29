json.array!(@engagement_types) do |engagement_type|
  json.extract! engagement_type, :name
  json.url engagement_type_url(engagement_type, format: :json)
end
