json.places places do |json, place|
  json.(place, :id, :name)
end

json.organisations organisations do |json, organisation|
  json.(organisation, :id, :name)
end

json.students students do |json, student|
  json.(student, :id, :name)
  json.organisation_id student.current_work_place
end
