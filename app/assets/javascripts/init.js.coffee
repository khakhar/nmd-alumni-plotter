$(document).ready ()->

  window.initTypeAheads = ->
    if window.invite_token?
      invite_string = "&invite_token=#{window.invite_token}"
    else
      invite_string = ""

    placesUrl = "/places/search.json?q=%QUERY#{invite_string}"
    backgroundsUrl = "/backgrounds/search.json?q=%QUERY#{invite_string}"
    organisationsUrl = "/organisations/search.json?q=%QUERY#{invite_string}"

    $('.place_name').typeahead(name: 'places', remote: placesUrl)
    $('.background_name').typeahead(name: 'backgrounds', remote: backgroundsUrl)


    $(".organisation_name").on "typeahead:selected", (event, selection)->
      if selection['website']?
        $(this).parents(".work-place").find('.organisation_website').val(selection['website'])

    $('.organisation_name').typeahead(
      name: 'organisations'
      limit: 10
      remote:
        url: organisationsUrl
        filter: (organisations)->
          optionsList = []
          for organisation in organisations
            optionsList.push {value: organisation['name'], website: organisation['website']}
          optionsList
    )


  window.destroyTypeAheads = ->
    $('.place_name, .background_name, .organisation_name').typeahead('destroy');


  onEngagementTypeChange = ()->
    label = $(this).find('option:selected').text()
    if label.match(new RegExp("internship", "ig"))
      $(this).parents('.work-place').find('.project-title-wrapper').show()
    else
      $(this).parents('.work-place').find('.project-title-wrapper').hide()


  @onSortStart = (event, ui)->
    destroyTypeAheads()


  @onSortStop = (event, ui)->
    for i in [0..($(".student-background").length)]
      if $(".student-background").eq(i).find(".background-order").length > 0
        $(".student-background").eq(i).find(".background-order").eq(0).val(i)
    initTypeAheads()

  $(".student-backgrounds").bind("sortstop", @onSortStop).bind("sortstart", @onSortStart)
  $(document).on "change", ".engagement_type_id", onEngagementTypeChange
  $(".engagement_type_id").each onEngagementTypeChange


  if $(".student-background").length > 0
    $(".student-backgrounds").sortable(handle: ".handle")
    @onSortStop()


  $(".student-backgrounds").on "cocoon:after-insert", (e, insertedItem)=>
    if $(".student-background").length > 1
      $(".student-backgrounds").sortable("destroy")
    $(".student-backgrounds").sortable(handle: ".handle")
    @onSortStop()


  $(".work_places").on "cocoon:after-insert", (e, insertedItem)=>
    initTypeAheads()

  initTypeAheads()
