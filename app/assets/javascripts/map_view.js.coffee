class window.MapView
  options:
    worldCenter:    new L.LatLng(37.3002752813443, 5.625)
    indiaCenter:    new L.LatLng(24.406094315764562, 78.68738756528921)
    indiaZoomLevel: 4
    worldZoomLevel: 2
    cloudMade:
      apiKey:  "fe1dbd920bce412faf852270ad2ee911"
      styleId: "22677"


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
    L.marker(latlng).bindPopup(popupMarkup, options)


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


  plot: (onlyLocationFilterChange=false)=>
    @markerLayer.clearLayers()
    expertise = $("#expertise").val()
    plotBy    = $("#plot-by").val()

    successCallback = (data)=>
      @students = data
      @["markersBy#{plotBy}Location"]()

    if onlyLocationFilterChange == true
      successCallback(@students)
      return

    params = {expertise: $("#expertise").val()}
    $.get("/students/search.json", params, successCallback)

