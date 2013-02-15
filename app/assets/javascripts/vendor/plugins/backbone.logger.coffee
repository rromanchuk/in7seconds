Log =
  trace: true

  logPrefix: '[app]:'

  log: (args...) ->
    return unless @trace
    if @logPrefix then args.unshift(@logPrefix)
    console?.log?(args...)
    @

_.extend(Backbone.Collection.prototype, Log)
_.extend(Backbone.Model.prototype, Log)
_.extend(Backbone.View.prototype, Log)
_.extend(Backbone.Router.prototype, Log)

Backbone.Log = Log
