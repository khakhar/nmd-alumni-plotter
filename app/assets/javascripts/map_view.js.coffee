class window.MapView
  osmUrl:        'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
  osmAttrib:     'Map data © OpenStreetMap contributors'
  worldCenter:    new L.LatLng(37.3002752813443, 5.625)
  indiaCenter:    new L.LatLng(24.406094315764562, 78.68738756528921)
  indiaZoomLevel: 4
  worldZoomLevel: 2

  constructor: (containerId, @students)->
    L.Icon.Default.imagePath = "/assets"
    @map = L.map('map')
    @addOSMLayer()
    @map.setView(@indiaCenter, @indiaZoomLevel)
    @markerLayer = L.layerGroup([])
    @map.addLayer(@markerLayer)


  addOSMLayer: ->
    osm = new L.TileLayer(@osmUrl, {minZoom: 2, maxZoom: 15, attribution: @osmAttrib})
    @map.addLayer(osm)


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
