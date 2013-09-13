class Maintenance
  def clear_data!
    Student.delete_all
    WorkPlace.delete_all
    Organisation.delete_all
    Place.delete_all
  end
end