class Maintenance
  def self.clear_data!
    Student.delete_all
    WorkPlace.delete_all
    Organisation.delete_all
    Place.delete_all
    Background.delete_all
  end


  def self.populate_with_samples!
    names = 10.times.collect { Faker::Name.name }
    backgrounds = ["Computer Science", "Electronics", "Graphic Design", "Journalism"]

    cities = [
      "Mumbai",
      "Delhi",
      "Bangalore",
      "Hyderabad",
      "Ahmedabad",
      "Chennai",
      "Kolkata",
      "Surat",
      "Pune",
      "Jaipur",
      "Lucknow",
      "Kanpur",
      "Nagpur",
      "Indore",
      "Ranchi",
      "Bhopal",
      "Visakhapatnam",
      "Patna",
      "Agra",
      "Kutch",
      "Navi Mumbai",
      "Coimbatore",
      "Vijayawada",
      "Madurai",
      "Mysore",
      "Tiruchirappalli",
      "Salem",
      "Noida",
      "Jamshedpur",
      "Mangalore",
      "Durgapur",
      "Tirunelveli",
      "Muzaffarnagar"
    ]


    organisations = [
      "Google",
      "IBM",
      "Dell",
      "BHEL",
      "ISRO",
      "NavSat",
      "Exotel",
      "SupportBee",
      "VisualWebOptimizer",
      "ChargeBee",
      "TableGrabber",
      "Explora",
      "Mozilla",
      "Wikipedia",
      "CommonFloor",
      "JustDial",
      "Infosys",
      "Wipro",
      "MindTree",
      "Accenture",
      "Dhruva",
      "Cisco",
      "BigBasket",
      "Flipkart",
      "DotAhead",
      "FreshDesk",
      "Times Internet",
      "Robosoft",
      "ZipDial",
      "HashCube",
      "WebEngage",
      "HapPay"
    ]


    backgrounds.each { |background| Background.find_or_create_by(name: background) }

    organisations.each do |organisation|
      organisation = Organisation.find_or_initialize_by name: organisation
      organisation.website = Faker::Internet.url
      organisation.save
    end

    cities.each { |city| Place.find_or_create_by(name: city) }

    all_places = Place.all
    all_backgrounds    = Background.all
    all_organisations  = Organisation.all
    areas_of_expertise = ExpertiseArea.all

    names.each do |name|
      student = Student.find_or_initialize_by name: name
      student.place_id = all_places.sample.id
      student.background_id = all_backgrounds.sample.id
      student.expertise_area_id = areas_of_expertise.sample.id
      student.website = Faker::Internet.url
      student.save

      student.work_places.create(
        organisation_id: all_organisations.sample.id,
        current: false,
        place_id: all_places.sample.id,
        project_title: Faker::Lorem.words.join(" "),
        engagement_type_id: EngagementType.internship.id
      )

      student.work_places.create(
        organisation_id: all_organisations.sample.id,
        current: true,
        place_id: all_places.sample.id,
        engagement_type_id: EngagementType.job.id
      )
    end


    all_students = Student.all

    # More students to have the same workplace as te before ones
    10.times.collect do
      name = Faker::Name.name

      first_sample  = all_students.sample
      second_sample = all_students.sample

      student = Student.new name: name
      student.place_id = first_sample.place_id
      student.background_id = all_backgrounds.sample.id
      student.expertise_area_id = areas_of_expertise.sample.id
      student.website = Faker::Internet.url
      student.save

      student.work_places.create(
        organisation_id: first_sample.internship.organisation_id,
        current: false,
        place_id: first_sample.internship.place_id,
        project_title: Faker::Lorem.words.join(" "),
        engagement_type_id: EngagementType.internship.id
      )

      student.work_places.create(
        organisation_id: second_sample.current_work_place.organisation_id,
        current: true,
        place_id: second_sample.current_work_place.place_id,
        engagement_type_id: EngagementType.job.id
      )
    end
  end
end