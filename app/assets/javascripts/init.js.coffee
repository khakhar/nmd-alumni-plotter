$(document).ready ()->
  if $("#map").length > 0
    mapView = new MapView('map', window.students)

    $("#expertise").change -> mapView.plot()
    $("#plot-by").change -> mapView.plot(true)

    mapView.plot(true)


  $('.place_name').typeahead(
    name: 'places'
    remote: '/places/search.json?q=%QUERY'
  )


  $('.organisation_name').typeahead(
    name: 'organisations'
    remote: '/organisations/search.json?q=%QUERY'
    limit: 10
  )
