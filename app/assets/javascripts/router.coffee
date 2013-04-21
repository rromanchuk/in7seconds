models = {}
collections = {}
views = {}

cleanup = (hash = {}, skip = [])->
  for key of hash
    if not (key in skip)
      hash[key].destroy?()
      delete hash[key]

cleanAll = ->
  cleanup(models)
  cleanup(collections)
  cleanup(views)

Router = Backbone.Router.extend
  trace: app.env.debug
  logPrefix: '[app.Router]:'

  _historyLimit: 10
  history: []

  routes:
    '':                          'index'
    'feed':                      'feed'

    'matches':                   'matches'
    'profile':                   'profile'

    'about':                     'about'

    '*any':                      'error'

  before: (route, params)->
    @log("#{route} route called")
    cleanup(views)
    app.size.setSplash(app.dom.html.hasClass('splash'))

  initialize: ->
    @on('route', @_manageHistory)
    @log('initialize')

  _manageHistory: (rule, params...) ->
    @history.unshift(window.location.href)

    if @history.length > @_historyLimit
      @history.length = @_historyLimit  

  index: ->
    @log('match "index"')
    views['index'] = new app.views.PageIndex()
    app.social.render()

  feed: ->
    @log('match "feed"')
    views['feed'] = new app.views.PageFeed(
      collection: new app.collections.Hookups()
      )

  matches: ->
    @log('match "matches"')
    views['matches'] = new app.views.PageMatches(
      collection: new app.collections.Matches()
      )

  profile: ->
    @log('match "profile"')
    views['profile'] = new app.views.PageProfile()

  about: ->
    @log('match "about"')
    app.social.render()

  error: ->
    @log('match "error"')

app.Router = Router
