class Analytics
  trace: app.env.debug
  logPrefix: '[app.modules.Analytics]:'
  log: Backbone.Log.log

  constructor: ->
    @trackEvents()
    @log('initialize')

  routeChanged: (router, route)->
    _gaq.push(['_trackPageview', route])

  userChanged: (user, event)->
    _gaq.push(['_trackEvent', 'User/status', user.status or 'null'])
    _gaq.push(['_trackEvent', 'User/name', user.name + ', id' + user.id])

    _gaq.push(['_trackEvent', 'User/sex', user.sex or 'null'])

    _gaq.push(['_trackEvent', 'User/from-to', app.user.name + ', id' + app.user.id, user.name + ', id' + user.id])
    _gaq.push(['_trackEvent', 'User/to-from', user.name + ', id' + user.id, app.user.name + ', id' + app.user.id])

    if user.status is 'mutual'
      _gaq.push(['_trackEvent', 'User/mutual', app.user.name + ', id' + app.user.id, user.name + ', id' + user.id])

    if app.user.sex is 'male' and user.sex is 'female'
      _gaq.push(['_trackEvent', 'User/sex/m-f', app.user.name + ', id' + app.user.id, user.name + ', id' + user.id])

    if app.user.sex is 'male' and user.sex is 'male'
      _gaq.push(['_trackEvent', 'User/sex/m-m', app.user.name + ', id' + app.user.id, user.name + ', id' + user.id])

    if app.user.sex is 'female' and user.sex is 'female'
      _gaq.push(['_trackEvent', 'User/sex/f-f', app.user.name + ', id' + app.user.id, user.name + ', id' + user.id])

    if app.user.sex is 'female' and user.sex is 'male'
      _gaq.push(['_trackEvent', 'User/sex/f-m', app.user.name + ', id' + app.user.id, user.name + ', id' + user.id])

  userRefreshed: (loaded)->
    _gaq.push(['_trackEvent', 'User', 'friends_count', loaded.length + ''])

  userApiError: (record, xhr, settings, error) ->
    _gaq.push(['_trackEvent', 'API/error/' + xhr.status, xhr.responseText or 'null'])

  trackEvents: ->
    Spine.Route.on('change', @routeChanged)
    app.models.User.on('change', @userChanged)
    app.models.User.on('refresh', @userRefreshed)
    app.models.User.on('ajaxError', @userApiError)

    @log('listening to events')

app.modules.Analytics = Analytics
