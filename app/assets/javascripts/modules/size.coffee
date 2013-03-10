class Size
  _min_width: 960
  _min_height: 600

  _isSplash: false

  constructor: ->
    @width = null
    @height = null

    @header =
      width: app.dom.header.width()
      height: app.dom.header.height()

    @footer =
      width: app.dom.footer.width()
      height: app.dom.footer.height()

    @content =
      width: null
      height: null

    app.dom.win.on('resize', @resize)
    @resize()

  setSplash: (@_isSplash) ->
    if @_isSplash
      app.dom.content.css(height: @content.height)
    else
      app.dom.content.css(height: 'auto')

  resize: =>
    @width = app.dom.win.width()
    @height = app.dom.win.height()

    @width = Math.max(@_min_width, @width)
    @height = Math.max(@_min_height, @height)

    @content.width = @width - @header.width - @footer.width
    @content.height = @height - @header.height - @footer.height

    app.dom.content.css(height: @content.height) if @_isSplash

    app.trigger('resize',
      width: @width
      height: @height
      )


app.modules.Size = Size
