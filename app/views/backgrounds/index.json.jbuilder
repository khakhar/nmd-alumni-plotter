json.array!(@expertise_areas) do |expertise_area|
  json.extract! expertise_area, :name
  json.url expertise_area_url(expertise_area, format: :json)
end
