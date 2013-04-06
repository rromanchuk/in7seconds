BlockGame = Backbone.View.extend
  trace: app.env.debug
  logPrefix: '[app.views.BlockGame]:'

  el: '#l-content .p-feed'

  initialize: ->
    # @loadHookups()
    @render()

    @currentUser = 0

    @log('initialize')

  events:
    'click .b-g-start':     'startGame'

  postRender: ->
    @introEl = @$el.find('.p-g-intro')
    @gameEl = @$el.find('.p-g-content')

    @log('post render')

  startGame: ->
    @introEl.hide()
    @renderUser()
    @gameEl.show()

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

  renderUser: ->
    @gameEl.html(app.templates.block_game_user(@collection.at(@currentUser).toJSON()))

    @currentUser++

  destroy: ->
    @undelegateEvents()

    @log('destroyed')

app.views.BlockGame = BlockGame
