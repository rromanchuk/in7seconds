PageFeed = Backbone.View.extend
  trace: app.env.debug
  logPrefix: '[app.views.PageFeed]:'

  el: '#l-content'

  initialize: ->
    @render()

    @log('initialize')

  # events:

  render: ->
    @$el.html(app.templates.page_feed())

  destroy: ->
    @undelegateEvents()

    @log('destroyed')

app.views.PageFeed = PageFeed
