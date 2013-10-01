$(document).ready ()->
  $('.place_name').typeahead(
    name: 'places'
    remote: '/places/search.json?q=%QUERY'
  )


  $('.background_name').typeahead(
    name: 'backgrounds'
    remote: '/backgrounds/search.json?q=%QUERY'
  )


  $(".organisation_name").on "typeahead:selected", (event, selection)->
    if selection['website']?
      $(this).parents(".work-place").find('.organisation_website').val(selection['website'])


  $('.organisation_name').typeahead(
    name: 'organisations'
    limit: 10
    remote:
      url: '/organisations/search.json?q=%QUERY'
      filter: (organisations)->
        optionsList = []
        for organisation in organisations
          optionsList.push {value: organisation['name'], website: organisation['website']}
        optionsList
  )


  onEngagementTypeChange = ()->
    label = $(this).find('option:selected').text()
    if label.match(new RegExp("internship", "ig"))
      $(this).parents('.work-place').find('.project-title-wrapper').show()
    else
      $(this).parents('.work-place').find('.project-title-wrapper').hide()


  @onSortStart = (event, ui)->
    # nothing here


  @onSortStop = (event, ui)->
    for i in [0..($(".student-background").length)]
      if $(".student-background").eq(i).find(".background-order").length > 0
        $(".student-background").eq(i).find(".background-order").eq(0).val(i)
      console.log $(".student-background").eq(i).find(".background-order").eq(0).val()

  $(".student-backgrounds").bind("sortstop", @onSortStop).bind("sortstart", @onSortStart)
  $(".engagement_type_id").on 'change', onEngagementTypeChange
  $(".engagement_type_id").each onEngagementTypeChange


  if $(".student-background").length > 0
    $(".student-backgrounds").sortable(handle: ".handle")
    @onSortStop()
    $(".student-backgrounds").on "cocoon:after-insert", (e, insertedItem)=>
      $(".student-backgrounds").sortable("destroy")
      $(".student-backgrounds").sortable(handle: ".handle")
      @onSortStop()
