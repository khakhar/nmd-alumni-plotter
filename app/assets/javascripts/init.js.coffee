$(document).ready ()->
  $('.place_name').typeahead(
    name: 'places'
    remote: '/places/search.json?q=%QUERY'
  )


  $('.organisation_name').typeahead(
    name: 'organisations'
    remote: '/organisations/search.json?q=%QUERY'
    limit: 10
  )
