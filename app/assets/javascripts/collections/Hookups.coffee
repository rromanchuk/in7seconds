Hookups = Backbone.Collection.extend
  trace: app.env.debug
  logPrefix: '[app.collections.Hookups]:'

  model: app.models.User

  initialize: () ->
    @log('initialize')

app.collections.Hookups = Hookups
