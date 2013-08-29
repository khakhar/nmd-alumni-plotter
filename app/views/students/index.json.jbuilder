json.array!(@students) do |student|
  json.extract! student, :name, :place_id
  json.url student_url(student, format: :json)
end
