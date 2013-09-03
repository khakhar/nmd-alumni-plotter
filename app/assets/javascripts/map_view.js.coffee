class window.MapView
  options:
    worldCenter:    new L.LatLng(37.3002752813443, 5.625)
    indiaCenter:    new L.LatLng(22.248428704383624, 77.783203125)
    indiaZoomLevel: 5
    worldZoomLevel: 2
    cloudMade:
      apiKey:  "fe1dbd920bce412faf852270ad2ee911"
      styleId: "22677"


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


  constructor: (containerId, @students)->
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


  createMarker: (student, lat, lng)->
    latlng = new L.LatLng(lat, lng)
    popupMarkup = """
      <div class='student_name'>#{student.name}</div>
      <div class='expertise'>#{student.expertise_area.name}</div>
    """

    if student.internship
      popupMarkup += """
        <div class='popup-field'>Interned at:
          <div class='popup-field-value'>
            #{student.internship.organisation.name},
            #{student.internship.place.name}
          </div>
        </div>
      """

    if student.current_work_place
      popupMarkup += """
        <div class='popup-field'>Currently at:
          <div class='popup-field-value'>
            #{student.current_work_place.organisation.name},
            #{student.current_work_place.place.name}
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
    for student in @students
      marker = @createMarker(
        student,
        student.place.latitude,
        student.place.longitude
      )
      @addMarker(marker)


  addMarker: (marker)->
    @markerLayer.addLayer(marker)


  plot: (plotBy, options={})=>
    @markerLayer.clearLayers()

    successCallback = (data)=>
      @students = data
      @["markersBy#{plotBy}Location"]()

    if options.useCache == true
      successCallback(@students)
      return

    $.get("/students/search.json", successCallback)

