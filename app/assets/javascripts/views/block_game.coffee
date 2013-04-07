BlockGame = Backbone.View.extend
  trace: app.env.debug
  logPrefix: '[app.views.BlockGame]:'

  el: '#l-content .p-feed'

  initialize: ->
    @loadHookups()

    @tid = null

    @currentUser = 0
    @currentCount = 0

    if app.env.debug
      window.COLLECTION = @collection

    @log('initialize')

  events:
    'click .b-g-start':            'startGame'
    'click .p-g-c-c-dislike':      'disLike'
    'click .p-g-c-c-like':         'like'


  postRender: ->
    @introEl = @$el.find('.p-g-intro')
    @gameEl = @$el.find('.p-g-content')
    @overEl = @$el.find('.p-g-over')
    @userEl = @gameEl.find('.p-g-c-user')

    @counterEl = @gameEl.find('.p-g-c-c-num')

    @startGame()

    @log('post render')

  startGame: ->
    @introEl.hide()
    @gameEl.show()

    @gameLoop()

    @log('game started')

  stopGame: ->
    @overEl.show()
    @gameEl.hide()

    @gameStop()

    @log('game started')

  updateHookup: (liked = false)->
    type = if liked then 'like' else 'dislike'

    $.ajax(
      url: app.api(type, id: @collection.at(@currentUser).get('id'))
      type: 'POST'
      )

  disLike: ->
    @updateHookup()

    @gameReset()

  like: ->
    @updateHookup(true)

    @gameReset()

  gameReset: ->
    window.clearTimeout(@tid) if @tid?
    @currentCount = 0
    @gameLoop()

  gameStop: ->
    window.clearTimeout(@tid) if @tid?
    @currentCount = 0

  gameLoop: ->
    theLoop = =>
      @currentCount--

      if @currentCount <= 0
        @nextUser()

      @counterEl.html(@currentCount)
      @tid = window.setTimeout(theLoop, 1000)

    theLoop()

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
    user = @collection.at(@currentUser)
    @stopGame unless user

    @userEl.html(app.templates.block_game_user(user.toJSON()))

  destroy: ->
    @undelegateEvents()

    @log('destroyed')

app.views.BlockGame = BlockGame
