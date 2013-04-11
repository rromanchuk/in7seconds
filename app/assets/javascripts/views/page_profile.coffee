PageProfile = Backbone.View.extend
  trace: app.env.debug
  logPrefix: '[app.views.PageProfile]:'

  el: '#l-content'

  initialize: ->
    @render()

    @formEl = @$el.find('.p-p-u-settings')
    @emailEl = @$el.find('.p-p-u-email')

    @form = @formEl.m_formValidate()[0]

    @log('initialize')

  events:
    'blur .p-p-u-email':          'formValidate'
    'valid .p-p-u-settings':      'formSubmit'

  formValidate: ->
    @formEl.submit()

  formSubmit: (evt, e)->
    app.e(e)
    app.user.email = $.trim(@emailEl.val())

    $.ajax(
      url: app.api('profile')
      type: 'put'
      data: 
        'user[email]': app.user.email
      success: _.bind(@showSaved, @)
      )

    @log("saving new email: #{app.user.email}")

  showSaved: ->
    # FIXME: add notifications
    # app.notifications.show(
    #   type: 'success'
    #   msg: 'Профиль сохранен'
    #   )

    @$el.find('.p-p-u-saved').css(opacity: 1)
    setTimeout(=>
      @$el.find('.p-p-u-saved').css(opacity: 0)
    , 1000)

  render: ->
    @$el.html(app.templates.page_profile())

  destroy: ->
    @undelegateEvents()

    @form.destroy()

    @log('destroyed')

app.views.PageProfile = PageProfile
