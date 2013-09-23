class NmdPlot.Plotters.Native extends NmdPlot.Plotters.Base

  backgroundSorter = (a, b)=>
    if [@getBackground(a), @getBackground(b)].sort().indexOf(@getBackground(a)) == 0
      return -1
    return 1


  studentSorter = (a, b)=>
    if [@getStudent(a), @getStudent(b)].sort().indexOf(@getStudent(a)) == 0
      return -1
    return 1


  populateNavList: ()->
    # sort backgrounds by name
    for backgroundId in @sortedIds(@tmpGroups, backgroundSorter)
      $background = $("<div class='background-name'>").html(@getBackground(backgroundId))
      $(".nav-list .items").append($item)

      # cumulate studentIds for background
      studentIdsForBackground = []
      for placeId, studentIds of @currentGroups[backgroundId]
        studentIdsForBackground = studentIdsForBackground.concat(studentIds)

      # sort students by name
      for studentId in studentIdsForBackground.sort(studentSorter)
        studentId  = studentId
        student    = @getStudent(studentId)
        $itemLabel = $("<span>")
          .attr(id: "group-label-#{id}")
          .html(student.name)
          .data("group-id", groupId)

        $item = $("<div>").addClass("item").append($itemLabel)

        if @navListItems[id].website?
          $itemLink  = $("<a>")
            .attr(
              href: @navListItems[id].website
              target: "_blank"
            ).html("<img src='<%= asset_path('arrow.png') %>'/>")
          $item.append($itemLink)


      $itemLabel.click @labelOnClick
      $(".nav-list .items").append($item)


  labelOnClick: (event)=>
    groupId   = $(event.target).data("group-id")
    $(".item").removeClass("selected-item")
    $(event.target).parent().addClass("selected-item")

    @mapView.map.setDefaultIconOnMarkers(@previousMarkerIds)
    for placeId, studentIds of @currentGroups[groupId]
      @map.highlightMarker("group-#{groupId}-#{placeId}")
      @previousMarkerIds.push "group-#{groupId}-#{placeId}"


  createMarker: (studentIds, opts) ->
    markup = ""

    for studentId in studentIds
      student = NmdPlot.Utils.getStudent(studentId, data)
      markup += """
        <div class="student">
          <div class='student_name'>#{student.name}</div>
        </div>
      """
    opts['weight'] = studentIds.length
    @mapView.map.createMarker markup, opts


  groupData: ->
    for studentId, student of @data.students
      if !@currentGroups[student.background_id]
        @currentGroups[student.background_id] = {}

      if !@currentGroups[student.background_id][student.place_id]
        @currentGroups[student.background_id][student.place_id] = []
        @addPlace(student.place_id)

      @currentGroups[student.background_id][student.place_id].push(studentId)
    @tmpGroups = @currentGroups


  # Trying to filter using currentGroups would be a nightmare for cleaning up data
  filterGroups: (string)->
    for studentId, student of @data.students
      continue if !student.name.match(new RegExp(string, "gi"))

      if !@tmpGroups[student.background_id]
        @tmpGroups[student.background_id] = {}

      if !@tmpGroups[student.background_id][student.place_id]
        @tmpGroups[student.background_id][student.place_id] = []
        @addPlace(student.place_id)

      @tmpGroups[student.background_id][student.place_id].push(studentId)



  plot: (options={})->
    console.log options
    @resetState(options)

    if !options.filterPlot
      @groupData()
    else
      @filterGroups(options.filterString)


    for id, group of @tmpGroups
      @addItemToList(@getStudent(id).name, id, @getStudent(id).website)
      for placeId, studentIds of group
        @getPlace(placeId).name
        marker = @createMarker(
          studentIds,
          lat: @getPlace(placeId).latitude
          lng: @getPlace(placeId).longitude
          labelId:   "group-label-#{id}"
          leafletId: "group-#{id}-#{placeId}"
        )

    @populateNavList()
