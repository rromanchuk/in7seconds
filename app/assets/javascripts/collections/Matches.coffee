Matches = Backbone.Collection.extend
  trace: app.env.debug
  logPrefix: '[app.collections.Matches]:'

  model: app.models.User

  initialize: () ->
    @log('initialize')

app.collections.Matches = Matches
