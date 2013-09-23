class NmdPlot.Plotters.Base

  currentGroups: {}
  previousMarkerIds: []
  navListItems: {}
  placesWithMarkers: []
  tmpGroups: {}


  constructor: (@view, @data)->


  getStudent:      (id)-> @data.students[id]
  getOrganisation: (id)-> @data.organisations[id]
  getPlace:        (id)-> @data.places[id]
  getBackground:   (id)-> @data.backgrounds[id]


  organisationSorter: (a, b)=>
    if [@getOrganisation(a).name, @getOrganisation(b).name].sort().indexOf(@getOrganisation(a).name) == 0
      return -1
    return 1


  backgroundSorter: (a, b)=>
    if [@getBackground(a), @getBackground(b)].sort().indexOf(@getBackground(a)) == 0
      return -1
    return 1


  studentSorter: (a, b)=>
    if [@getStudent(a).name, @getStudent(b).name].sort().indexOf(@getStudent(a).name) == 0
      return -1
    return 1


  addPlace: (placeId)->
    return if @placesWithMarkers.indexOf(placeId) != -1
    @placesWithMarkers.push(placeId)
    @addMarkerForPlace(placeId)


  addMarkerForPlace: (placeId)->
    place = @getPlace(placeId)
    marker = @view.geo.createPlaceLabel(
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
    @currentGroups = {} if !options.filter


  markerId: ->
    args = Array.prototype.slice.call(arguments)
    "marker-#{args.join('-')}"


  labelId: (groupId, placeId)->
    args = Array.prototype.slice.call(arguments)
    "label-#{args.join('-')}"


  getStudentsMarkupForOrganisation: (organisationId)->
    $students = $("<div>").addClass("students")
    for placeId, studentIds of @currentGroups[organisationId]
      for studentId in studentIds
        student = @getStudent(studentId)
        $studentMarkup = $("<a>").attr('href', student.website).html(student.name)
        $student = $("<div>")
          .addClass("student")
          .html("- " + $studentMarkup)
        $students.append($student)
    $students
