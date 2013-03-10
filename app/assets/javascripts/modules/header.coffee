class Header
  menuActive: false

  constructor: ->
    @$el = app.dom.header

    @menuEl = @$el.find('.l-h-usermenu')
    @menuToggleEl = @menuEl.find('.l-h-u-top')

    @logic()

  logic: ->
    togglePopup = =>
      if @menuActive
        @menuEl.removeClass('active')
        @menuActive = false
      else
        @menuEl.addClass('active')
        @menuActive = true

    handleMisClick = (e)=>
      return true unless @menuActive
      if not $(e.target).is('.l-h-u-top') and not $(e.target).parents('.l-h-u-top').length
        togglePopup()

      true

    @menuToggleEl.on('click', togglePopup)
    app.dom.body.on('click', handleMisClick)

app.modules.Header = Header  
