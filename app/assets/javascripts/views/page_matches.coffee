PageMatches = Backbone.View.extend
  trace: app.env.debug
  logPrefix: '[app.views.PageMatches]:'

  el: '#l-content'

  initialize: ->
    @render()
    app.social.render()
    @log('initialize')

  # events:

  render: ->
    @$el.html(app.templates.page_matches())

  destroy: ->
    @undelegateEvents()

    @log('destroyed')

app.views.PageMatches = PageMatches
