class window.MapView
  currentGroups: {}
  previousMarkerIds: []
  navListItemNames: {}
  placesWithMarkers: []

  constructor: (containerId, @data)->
    @map = new LeafletMap(containerId)


  getStudent:      (id)-> @data.students[id]
  getOrganisation: (id)-> @data.organisations[id]
  getPlace:        (id)-> @data.places[id]



  addPlaceMarkers: ()->
    for placeId in @placesWithMarkers
      place = @getPlace(placeId)
      marker = @map.createPlaceLabel(
        place.name,
        lat: place.latitude,
        lng: place.longitude
      )


  populateNavList: ->
    names = (name for name, groupId of @navListItemNames)

    for name in names.sort()
      groupId   = @navListItemNames[name]
      $itemSpan = $("<span>").html(name)
      $item     = $("<div>").addClass("item").append($itemSpan)
      $itemSpan.data("group-id", groupId)

      $itemSpan.click (event)=>
        groupId   = $(event.target).data("group-id")
        @map.setDefaultIconOnMarkers(@previousMarkerIds)
        for placeId, studentIds of @currentGroups[groupId]
          @map.highlightMarker("group-#{groupId}-#{placeId}")
          @previousMarkerIds.push "group-#{groupId}-#{placeId}"

      $(".nav-list .items").append($item)


  addItemToList: (name, groupId)->
    @navListItemNames[name] = groupId


  createMarker: (studentIds, opts) ->
    markup = ""

    for studentId in studentIds
      markup += """
        <div class="student">
          <div class='student_name'>#{@getStudent(studentId).name}</div>
          <div class='expertise'>#{@getStudent(studentId).expertise_area_name}</div>
        </div>
      """
    opts['weight'] = studentIds.length
    @map.createMarker markup, opts


  markersByCurrentLocation: (opts)->
    if !opts.filterPlot
      for id, student of @data.students
        continue if !student.current_work_place_id
        if !@currentGroups[student.current_organisation_id]
          @currentGroups[student.current_organisation_id] = {}

        if !@currentGroups[student.current_organisation_id][student.current_place_id]
          @currentGroups[student.current_organisation_id][student.current_place_id] = []
        @currentGroups[student.current_organisation_id][student.current_place_id].push(id)

        if @placesWithMarkers.indexOf(student.current_place_id) == -1
          @placesWithMarkers.push(student.current_place_id)

      @addPlaceMarkers()
      @tmpGroups = @currentGroups
    else
      for id, group of @currentGroups
        if @getOrganisation(id).match(new RegExp(opts.filterString, "gi"))
          @tmpGroups[id] = group


    for id, group of @tmpGroups
      @addItemToList(@getOrganisation(id), id)
      for placeId, studentIds of group
        @getPlace(placeId).name
        marker = @createMarker(
          studentIds,
          lat: @getPlace(placeId).latitude,
          lng: @getPlace(placeId).longitude
          leafletId: "group-#{id}-#{placeId}"
        )


  markersByInternshipLocation: (opts)->
    if !opts.filterPlot
      for id, student of @data.students
        continue if !student.internship_place_id
        if !@currentGroups[student.internship_organisation_id]
          @currentGroups[student.internship_organisation_id] = {}
        if !@currentGroups[student.internship_organisation_id][student.internship_place_id]
          @currentGroups[student.internship_organisation_id][student.internship_place_id] = []
        @currentGroups[student.internship_organisation_id][student.internship_place_id].push(id)

        if @placesWithMarkers.indexOf(student.internship_place_id) == -1
          @placesWithMarkers.push(student.internship_place_id)

      @addPlaceMarkers()
      @tmpGroups = @currentGroups
    else
      for id, group of @currentGroups
        if @getOrganisation(id).match(new RegExp(opts.filterString, "gi"))
          @tmpGroups[id] = group


    for id, group of @tmpGroups
      @addItemToList(@getOrganisation(id), id)
      for placeId, studentIds of group
        @getPlace(placeId).name
        marker = @createMarker(
          studentIds,
          lat: @getPlace(placeId).latitude,
          lng: @getPlace(placeId).longitude
          leafletId: "group-#{id}-#{placeId}"
        )


  markersByNativeLocation: (opts)->
    if !opts.filterPlot
      for id, student of @data.students
        @currentGroups[id] = {}
        @currentGroups[id][student.place_id] = [id]

        if @placesWithMarkers.indexOf(student.place_id) == -1
            @placesWithMarkers.push(student.place_id)

      @addPlaceMarkers()
      @tmpGroups = @currentGroups
    else
      for id, group of @currentGroups
        if @getStudent(id).name.match(new RegExp(opts.filterString, "gi"))
          @tmpGroups[id] = group

    for id, group of @tmpGroups
      @addItemToList(@getStudent(id).name, id)
      for placeId, studentIds of group
        @getPlace(placeId).name
        marker = @createMarker(
          studentIds,
          lat: @getPlace(placeId).latitude,
          lng: @getPlace(placeId).longitude
          leafletId: "group-#{id}-#{placeId}"
        )


  plot: (plotBy, filterPlot=false, filterString="")=>
    $(".nav-list .items").empty()
    @currentPlotType   = plotBy
    @navListItemNames  = []
    @previousMarkerIds = []
    @tmpGroups = {}

    if !filterPlot
      @currentGroups = {}
      @placesWithMarkers = []

    @map.clear()
    @["markersBy#{plotBy}Location"]({filterPlot: filterPlot, filterString: filterString})
    @populateNavList()

