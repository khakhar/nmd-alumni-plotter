class window.MapView
  options:
    worldCenter:    new L.LatLng(37.3002752813443, 5.625)
    indiaCenter:    new L.LatLng(22.248428704383624, 77.783203125)
    indiaZoomLevel: 5
    worldZoomLevel: 2
    cloudMade:
      apiKey:  "fe1dbd920bce412faf852270ad2ee911"
      styleId: "22677"

  $navList: $(".nav-list")


  customIcon:
    L.icon(
      iconUrl: '/assets/marker-icon.png',
      # shadowUrl: 'leaf-shadow.png',

      iconSize:     [16, 16], # size of the icon
      # shadowSize:   [50, 64], # size of the shadow
      iconAnchor:   [8, 8], # point of the icon which will correspond to marker's location
      # shadowAnchor: [4, 62],  # the same for the shadow
      popupAnchor:  [0, 0] # point from which the popup should open relative to the iconAnchor
    )


  constructor: (containerId, @data)->
    L.Icon.Default.imagePath = "/assets"
    @map = L.map('map')
    @addCloudMadeLayer()
    @map.setView(@options.indiaCenter, @options.indiaZoomLevel)
    @markerLayer = L.layerGroup([])
    @map.addLayer(@markerLayer)


  addOSMLayer: ->
    osm = new L.TileLayer(
      'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
       minZoom: 2,
       maxZoom: 15,
       attribution: 'Map data &copy; OpenStreetMap contributors'
    )
    @map.addLayer(osm)


  addCloudMadeLayer: ->
    cloudmade = L.tileLayer(
      'http://{s}.tile.cloudmade.com/{key}/{styleId}/256/{z}/{x}/{y}.png',
      attribution: 'Map data &copy; 2011 OpenStreetMap contributors, Imagery &copy; 2011 CloudMade',
      key: @options.cloudMade.apiKey,
      styleId: @options.cloudMade.styleId
    ).addTo(@map)


  getStudent: (id)->
    @data.students[id]


  getOrganisation: (id)->
    @data.organisations[id]


  getPlace: (id)->
    @data.places[id]


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
    L.marker(latlng, icon: @customIcon).bindPopup(popupMarkup, options)


  markersByCurrentLocation: ->
    for student in @students
      continue if !student.current_work_place
      marker = @createMarker(
        student,
        student.current_work_place.place.latitude,
        student.current_work_place.place.longitude
      )
      @addMarker(marker)


  markersByInternshipLocation: ->
    for student in @students
      continue if !student.internship
      marker = @createMarker(
        student,
        student.internship.place.latitude,
        student.internship.place.longitude
      )
      @addMarker(marker)


  markersByNativeLocation: ->
    $navList.empty()

    for id, student of @data.students

      marker = @createMarker(
        id,
        lat: @getPlace(student.place_id).latitude,
        lng: @getPlace(student.place_id).longitude
      )
      @addMarker(marker)


  addMarker: (marker)->
    @markerLayer.addLayer(marker)


  plot: (plotBy)=>
    @markerLayer.clearLayers()
    @["markersBy#{plotBy}Location"]()


