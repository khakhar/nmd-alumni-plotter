json.array!(@organisations) do |organisation|
  json.extract! organisation, :name
  json.url organisation_url(organisation, format: :json)
end
