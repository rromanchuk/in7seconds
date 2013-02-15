PageMatches = Backbone.View.extend
  trace: app.env.debug
  logPrefix: '[app.views.PageMatches]:'

  el: '#l-content'

  initialize: ->
    @destroyed = false

    @render()

    @pageEl = @$el.find('.p-matches')
    @listEl = @$el.find('.p-m-list')

    @loadMatches()

    @log('initialize')

  # events:

  postRender: ->
    @pageEl.addClass('loaded')
    app.social.render()

  render: ->
    @$el.html(app.templates.page_matches())

  loadMatches: ->
    $.ajax(
      url: app.api('matches')
      success: (resp)=>
        return if @destroyed

        # FU Ryan. Do something right for once!
        # data = for item in resp
        #   item.birthday = item.birthday.split('T')[0]
        #   item

        @collection.add(resp)

        @renderMatches() if @collection.length
        @postRender()
      error: =>
        return if @destroyed
        @pageEl.addClass('error')
      )

  renderMatches: ->
    html = for match in @collection.toArray()
      app.templates.block_match_user(match.toJSON())

    @listEl.html(html.join(''))

  destroy: ->
    @undelegateEvents()

    @destroyed = true

    @log('destroyed')

app.views.PageMatches = PageMatches
