json.students do |json|
  students.each do |student|
    json.set! student.id do |json|
      json.set! :name,                student.name
      json.set! :place_id,            student.place_id
      json.set! :expertise_area_name, student.expertise_area.name

      json.set! :current_work_place_id,   student.current_work_place.try(:id)
      json.set! :current_organisation_id, student.current_work_place.try(:organisation_id)
      json.set! :current_place_id,        student.current_work_place.try(:place_id)

      json.set! :internship_id,              student.internship.try(:id)
      json.set! :internship_organisation_id, student.internship.try(:organisation_id)
      json.set! :internship_place_id,        student.internship.try(:place_id)
    end
  end
end


json.places do |json|
  places.each do |place|
    json.set! place.id do |json|
      json.name      place.name
      json.latitude  place.latitude
      json.longitude place.longitude
    end
  end
end


json.organisations do |json|
  organisations.each do |organisation|
    json.set! organisation.id, organisation.name
  end
end