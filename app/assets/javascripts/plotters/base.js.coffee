class NmdPlot.Plotters.Base

  currentGroups: {}
  previousMarkerIds: []
  navListItems: {}
  placesWithMarkers: []
  tmpGroups: {}


  constructor: (@mapView, @data)->


  addPlace: (placeId)->
    return if @placesWithMarkers.indexOf(placeId) != -1
    @placesWithMarkers.push(placeId)
    @addMarkerForPlace(placeId)


  addMarkerForPlace: (placeId)->
    place = @getPlace(placeId)
    marker = @mapView.map.createPlaceLabel(
      place.name,
      lat: place.latitude,
      lng: place.longitude
    )


  sortedIds: (obj, sorter)->
    ids = (key for key, value of obj)
    ids.sort(sorter)


  resetState: (options)->
    @navListItems      = []
    @previousMarkerIds = []
    @placesWithMarkers = []
    @tmpGroups = {}
    @currentGroups = {} if !options.filterPlot


  getStudent:      (id)-> @data.students[id]
  getOrganisation: (id)-> @data.organisations[id]
  getPlace:        (id)-> @data.places[id]


  getStudentsMarkupForOrganisation: (organisationId)->
    $students = $("<div>").addClass("students")
    for placeId, studentIds of @currentGroups[organisationId]
      for studentId in studentIds
        $student  = $("<div>")
          .addClass("student")
          .html("- " + @getStudent(studentId).name)
        $students.append($student)
    $students
