BlockGame = Backbone.View.extend
  trace: app.env.debug
  logPrefix: '[app.views.BlockGame]:'

  el: '#l-content .p-feed'

  initialize: ->
    @loadHookups()

    @log('initialize')

  events:
    'click .b-g-start':     'startGame'

  postRender: ->
    @log('post render')

  startGame: ->
    @log('game started')

  loadHookups: ->
    $.ajax(
      url: app.api('hookups')
      success: (resp)=>
        @collection.add(resp.possible_hookups)
        @render()
      error: =>
        @$el.addClass('error')
      )

  render: ->
    @$el.html(app.templates.block_game())
    @postRender()

  destroy: ->
    @undelegateEvents()

    @log('destroyed')

app.views.BlockGame = BlockGame
