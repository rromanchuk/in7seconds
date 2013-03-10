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
    cleanup(views)

  initialize: ->
    @on('route', @_manageHistory)
    @log('initialize')

  _manageHistory: (rule, params...) ->
    @history.unshift(window.location.href)

    if @history.length > @_historyLimit
      @history.length = @_historyLimit  

  index: ->
    @log('match "index"')

app.Router = Router
