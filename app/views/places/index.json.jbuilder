json.array!(@places) do |place|
  json.extract! place, :name, :country
  json.url place_url(place, format: :json)
end
