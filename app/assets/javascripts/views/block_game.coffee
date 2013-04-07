BlockGame = Backbone.View.extend
  trace: app.env.debug
  logPrefix: '[app.views.BlockGame]:'

  el: '#l-content .p-feed'

  initialize: ->
    @loadHookups()

    @currentUser = 0
    @currentCount = 0

    @log('initialize')

  events:
    'click .b-g-start':     'startGame'


  postRender: ->
    @introEl = @$el.find('.p-g-intro')
    @gameEl = @$el.find('.p-g-content')
    @userEl = @gameEl.find('.p-g-c-user')

    @counterEl = @gameEl.find('.p-g-c-c-num')

    @startGame()

    @log('post render')

  startGame: ->
    @introEl.hide()
    @gameEl.show()

    @gameLoop()

    @log('game started')

  gameLoop: ->
    @currentCount--

    if @currentCount <= 0
      @nextUser()

    @counterEl.html(@currentCount)

    window.setTimeout(_.bind(@gameLoop, @), 1000)

  nextUser: ->
    @renderUser()
    @currentUser++
    @currentCount = 7

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
    @userEl.html(app.templates.block_game_user(@collection.at(@currentUser).toJSON()))

  destroy: ->
    @undelegateEvents()

    @log('destroyed')

app.views.BlockGame = BlockGame
