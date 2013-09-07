class window.LeafletMap
  options:
    worldCenter:    new L.LatLng(37.3002752813443, 5.625)
    indiaCenter:    new L.LatLng(22.248428704383624, 77.783203125)
    indiaZoomLevel: 5
    worldZoomLevel: 2
    cloudMade:
      apiKey:  "fe1dbd920bce412faf852270ad2ee911"
      styleId: "22677"


  constructor: (containerId)->
    L.Icon.Default.imagePath = "/assets"
    @lmap = L.map('map')
    @addCloudMadeLayer()
    @lmap.setView(@options.indiaCenter, @options.indiaZoomLevel)
    @markerLayer = L.layerGroup([])
    @lmap.addLayer(@markerLayer)
    @


  setDefaultIconOnMarkers: (markerIds)->
    for markerId in markerIds
      @lmap._layers[markerId].setZIndexOffset(-50)
      if @markerLayer._layers[markerId]._map.hasLayer(@markerLayer._layers[markerId]._popup)
        @markerLayer._layers[markerId].closePopup()

      @markerLayer._layers[markerId].setIcon(@defaultIcon(@markerLayer._layers[markerId].weight))


  highlightMarker: (markerId)->
    @lmap._layers[markerId].setZIndexOffset(50)
    @lmap._layers[markerId].setIcon(@highlightIcon(@lmap._layers[markerId].weight))


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


  createMarker: (markup, opts) ->
    latlng = new L.LatLng(opts.lat, opts.lng)
    marker = L.marker(latlng, icon: @defaultIcon(opts.weight))
      .bindPopup(markup, {className: 'marker-popup'})
    marker.weight = opts.weight
    marker._leaflet_id = opts.leafletId if opts.leafletId
    marker.on "popupopen", =>
      marker.setZIndexOffset(50)

    marker.on "popupclose", =>
      marker.setIcon(@defaultIcon(marker.weight))
      marker.setZIndexOffset(-50)

    @markerLayer.addLayer(marker)


  clear: ->
    @markerLayer.clearLayers()


  highlightIcon: (size = 1)->
    size = size/2 if size > 1
    iconSize   = 8 * size
    anchorSize = iconSize/2
    L.icon(
      iconUrl: '/assets/red-icon.png',
      iconSize:     [iconSize, iconSize], # size of the icon
      iconAnchor:   [anchorSize, anchorSize], # point of the icon which will correspond to marker's location
      popupAnchor:  [0, 0] # point from which the popup should open relative to the iconAnchor
    )


  defaultIcon: (size = 1)->
    size = size/2 if size > 1
    iconSize   = 8 * size
    anchorSize = iconSize/2
    L.icon(
      iconUrl: '/assets/marker-icon.png',
      iconSize:     [iconSize, iconSize], # size of the icon
      iconAnchor:   [anchorSize, anchorSize], # point of the icon which will correspond to marker's location
      popupAnchor:  [0, 0] # point from which the popup should open relative to the iconAnchor
    )
