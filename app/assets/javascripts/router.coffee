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
  before: (route, params)->
    @log("#{route} route called")
    cleanup(views)
    app.size.setSplash(false)

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

    app.size.setSplash(true)
    app.social.render()

app.Router = Router
