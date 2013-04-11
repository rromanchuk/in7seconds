PageFeed = Backbone.View.extend
  trace: app.env.debug
  logPrefix: '[app.views.PageFeed]:'

  el: '#l-content'

  initialize: ->
    @render()

    @game = new app.views.BlockGame(
      collection: @collection
      )

    @log('initialize')

  # events:

  render: ->
    @$el.html(app.templates.page_feed())

  destroy: ->
    @undelegateEvents()

    @game?.destroy()
    delete @game

    @log('destroyed')

app.views.PageFeed = PageFeed
