PageIndex = Backbone.View.extend
  trace: app.env.debug
  logPrefix: '[app.views.PageIndex]:'

  el: '.p-index'
  delay: 3000
  duration: 300

  initialize: ->
    @screensListEl = @$el.find('.p-i-p-screens')
    @screensEls = @screensListEl.find('li')
    @screenHeight = @screensEls.eq(0).height()

    @shift = 0
    @length = @screensEls.length

    @startCarousel()

    @log('initialize')

  # events:

  startCarousel: ->
    slide = =>
      @shift++
      @shift = 0 if @shift >= @length

      @screensListEl.animate(top: -(@shift * @screenHeight), @duration)
      setTimeout(slide, @delay)

    setTimeout(slide, @delay)

  destroy: ->
    @undelegateEvents()

    @log('destroyed')

app.views.PageIndex = PageIndex
