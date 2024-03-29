class LinksManager

  constructor: ->
    @$el = app.dom.body

    @logic()

  logic: ->
    handleLocalRoute = (e)->
      el = $(e.target)
      
      if el.is('.app-route')
        url = $.trim(el.attr('href'))
      else
        url = $.trim(el.parents('.app-route').attr('href'))

      if url.length
        e.preventDefault()
        app.router.navigate(url, trigger: true) if url.length

    @$el.on('click', '.app-route', handleLocalRoute)

app.modules.LinksManager = LinksManager  
