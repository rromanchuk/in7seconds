BlockGame = Backbone.View.extend
  trace: app.env.debug
  logPrefix: '[app.views.BlockGame]:'

  el: '#l-content .p-feed'
  _preloadFactor: 20

  initialize: ->
    @tid = null

    @destroyed = false
    @fullyLoaded = false
    @rendered = false

    @currentUser = 0
    @currentCount = 7
    @length = 0

    @loadHookups()

    if app.env.debug
      window.COLLECTION = @collection

    @log('initialize')

  events:
    'click .p-g-c-c-dislike':      'disLike'
    'click .p-g-c-c-like':         'like'
    'click .b-g-start':            'startGame'

  postRender: ->
    @introEl = @$el.find('.p-g-intro')
    @gameEl = @$el.find('.p-g-content')
    @overEl = @$el.find('.p-g-over')
    @userEl = @gameEl.find('.p-g-c-user')

    @counterEl = @gameEl.find('.p-g-c-c-num')

    if @fullyLoaded
      @introEl.hide()
      @overEl.show()

    @log('post render')

  disLike: ->
    @updateHookup()

    @currentUser++
    @gameReset()

  like: ->
    @updateHookup(true)

    @currentUser++
    @gameReset()

  startGame: ->
    @introEl.hide()
    @gameEl.show()

    @gameLoop()

    @log('game started')

  stopGame: ->
    @overEl.show()
    @gameEl.hide()

    @gameStop()

    @log('game stopped')

  updateHookup: (liked = false)->
    return if @destroyed
    type = if liked then 'like' else 'dislike'

    $.ajax(
      url: app.api(type, id: @collection.at(@currentUser).get('id'))
      type: 'POST'
      )

  gameReset: ->
    window.clearTimeout(@tid) if @tid?

    @currentCount = 7
    @counterEl.html(@currentCount)

    @gameLoop()   

  gameStop: ->
    window.clearTimeout(@tid) if @tid?

  gameLoop: ->
    theLoop = =>
      @currentCount--

      if @currentCount <= 0
        @updateHookup()
        @nextUser()

      @counterEl.html(@currentCount)
      @tid = window.setTimeout(theLoop, 1000)

    @renderUser()
    @tid = window.setTimeout(theLoop, 1000)

  nextUser: ->
    return if @destroyed

    @currentCount = 7
    @currentUser++
    @renderUser()

    if @currentUser + @_preloadFactor >= @length and not @fullyLoaded
      @loadHookups()

  loadHookups: ->
    data = {}
    if (last = @collection.last())?
      data['last_id'] = last.get('id')

    $.ajax(
      url: app.api('hookups')
      data: data
      success: (resp)=>
        return if @destroyed

        if resp.length
          @collection.add(resp)
          @length = @collection.length
        else
          @fullyLoaded = true

        @render() unless @rendered
      error: =>
        @$el.addClass('error')
      )

  render: ->
    @$el.html(app.templates.block_game())
    @rendered = true
    @postRender()

  renderUser: ->
    user = @collection.at(@currentUser)

    if user
      @userEl.html(app.templates.block_game_user(user.toJSON()))
    else
      @stopGame()

  destroy: ->
    @undelegateEvents()

    window.clearTimeout(@tid) if @tid?
    @destroyed = true

    @log('destroyed')

app.views.BlockGame = BlockGame
