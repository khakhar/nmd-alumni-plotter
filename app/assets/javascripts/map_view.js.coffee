class window.MapView
  options:
    worldCenter:    new L.LatLng(37.3002752813443, 5.625)
    indiaCenter:    new L.LatLng(22.248428704383624, 77.783203125)
    indiaZoomLevel: 5
    worldZoomLevel: 2
    cloudMade:
      apiKey:  "fe1dbd920bce412faf852270ad2ee911"
      styleId: "22677"
  currentGroup: {}


  addItemToList: (name, markerId)->
    $item = $("<div>").addClass("item").html(name)
    $item.click =>
      @lmap._layers["#{markerId}"].fire("click")
    $(".nav-list .items").append($item)


  customIcon: (size = 1)->
    iconSize   = 8 * size
    anchorSize = iconSize/2
    L.icon(
      iconUrl: '/assets/marker-icon.png',
      # shadowUrl: 'leaf-shadow.png',

      iconSize:     [iconSize, iconSize], # size of the icon
      # shadowSize:   [50, 64], # size of the shadow
      iconAnchor:   [anchorSize, anchorSize], # point of the icon which will correspond to marker's location
      # shadowAnchor: [4, 62],  # the same for the shadow
      popupAnchor:  [0, 0] # point from which the popup should open relative to the iconAnchor
    )


  constructor: (containerId, @data)->
    L.Icon.Default.imagePath = "/assets"
    @lmap = L.map('map')
    @addCloudMadeLayer()
    @lmap.setView(@options.indiaCenter, @options.indiaZoomLevel)
    @markerLayer = L.layerGroup([])
    @lmap.addLayer(@markerLayer)


  addOSMLayer: ->
    osm = new L.TileLayer(
      'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
       minZoom: 2,
       maxZoom: 15,
       attribution: 'Map data &copy; OpenStreetMap contributors'
    )
    @lmap.addLayer(osm)


  addCloudMadeLayer: ->
    cloudmade = L.tileLayer(
      'http://{s}.tile.cloudmade.com/{key}/{styleId}/256/{z}/{x}/{y}.png',
      attribution: 'Map data &copy; 2011 OpenStreetMap contributors, Imagery &copy; 2011 CloudMade',
      key: @options.cloudMade.apiKey,
      styleId: @options.cloudMade.styleId
    ).addTo(@lmap)


  getStudent: (id)->
    @data.students[id]


  getOrganisation: (id)->
    @data.organisations[id]


  getPlace: (id)->
    @data.places[id]


  createGroupMarker: (studentIds, opts={className: 'marker-popup'}) ->
    latlng = new L.LatLng(opts.lat, opts.lng)
    popupMarkup = ""

    for studentId in studentIds
      popupMarkup += """
        <div class="student">
          <div class='student_name'>#{@getStudent(studentId).name}</div>
          <div class='expertise'>#{@getStudent(studentId).expertise_area_name}</div>
        </div>
      """

    options = {className: opts.className}
    L.marker(latlng, icon: @customIcon()).bindPopup(popupMarkup, options)



  createMarker: (studentId, opts={})->
    latlng = new L.LatLng(opts.lat, opts.lng)
    popupMarkup = """
      <div class='student_name'>#{@getStudent(studentId).name}</div>
      <div class='expertise'>#{@getStudent(studentId).expertise_area_name}</div>
    """

    if opts.internship? || opts.current_work_place?
      if opts.internship?
        engagementLabel  = "Interned at"
        organisationName = @getOrganisation(@getStudent(studentId).internship_organisation_id)
        placeName        = @getPlace(@getStudent(studentId).internship_place_id).name
      else
        engagementLabel  = "Currently at"
        organisationName = @getOrganisation(@getStudent(studentId).current_organisation_id)
        placeName        = @getPlace(@getStudent(studentId).current_place_id).name


      popupMarkup += """
        <div class='popup-field'>#{engagementLabel}
          <div class='popup-field-value'>
            #{organisationName},
            #{placeName}
          </div>
        </div>
      """

    options = {className: 'marker-popup'}
    L.marker(latlng, icon: @customIcon()).bindPopup(popupMarkup, options)


  markersByCurrentLocation: (opts)->
    @tmpGroups = {}
    @currentGroups = {} if !opts.filterPlot


    if !opts.filterPlot
      for id, student of @data.students
        continue if !student.current_work_place_id
        if !@currentGroups[student.current_organisation_id]
          @currentGroups[student.current_organisation_id] = {}
        if !@currentGroups[student.current_organisation_id][student.current_place_id]
          @currentGroups[student.current_organisation_id][student.current_place_id] = []
        @currentGroups[student.current_organisation_id][student.current_place_id].push(id)
      @tmpGroups = @currentGroups
    else
      for id, group of @currentGroups
        if @getOrganisation(id).match(new RegExp(opts.filterString, "gi"))
          @tmpGroups[id] = group

    for id, group of @tmpGroups
      @addItemToList(@getOrganisation(id), "group-#{id}")
      for placeId, studentIds of group
        @getPlace(placeId).name
        marker = @createGroupMarker(
          studentIds,
          lat: @getPlace(placeId).latitude,
          lng: @getPlace(placeId).longitude,
          className: "group-#{id}"
        )
        marker._leaflet_id = "group-#{id}"
        @addMarker(marker)



  markersByInternshipLocation: ->
    #TODO group by location
    for student in @students
      continue if !student.internship_id
      marker = @createMarker(
        student,
        lat: @getPlace(student.internship_place_id).latitude,
        lng: @getPlace(student.internship_place_id).longitude,
        className: "group-#{id}"
      )
      @addMarker(marker)


  markersByNativeLocation: ->
    for id, student of @data.students
      marker = @createMarker(
        id,
        lat: @getPlace(student.place_id).latitude,
        lng: @getPlace(student.place_id).longitude,
        className: "group-#{id}"
      )
      @addMarker(marker)


  addMarker: (marker)->
    @markerLayer.addLayer(marker)


  plot: (plotBy, filterPlot=false, filterString="")=>
    $(".nav-list .items").empty()
    @currentPlotType = plotBy
    @markerLayer.clearLayers()
    @["markersBy#{plotBy}Location"]({filterPlot: filterPlot, filterString: filterString})

