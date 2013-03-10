class Notifications
  trace: app.env.debug
  logPrefix: '[app.modules.Notifications]:'
  log: Spine.Log.log

  _count: 0
  _hideDelay: 2000
  _animationDuration: 300

  _mapIcon: (type)->
    switch type
      when 'success' then return 'checkmark-circle'
      when 'error' then return 'cancel-circle'
      when 'info' then return 'info'
      when 'warning' then return 'spam'

  _close: (e)=>
    @hide($(e.target).parent().attr('data-id'))

  constructor: (@settings)->
    @$el = $('#l-notifications')

    @$el.on('click', '.l-n-close', @_close)

  show: (opts)->
    id = @_count
    html = "<span data-id=\"#{id}\" class=\"l-notification\">
              <i class=\"icon-#{@_mapIcon(opts.type)} l-n-icon\"></i>
              #{opts.msg}
              <i class=\"icon-close l-n-close\"></i>
            </span>"
    fragment = $(html)

    @$el.append(fragment)

    window.setTimeout(=>
      fragment.css(opacity: 1)
    , 0)

    do (id)=>
      window.setTimeout(=>
        @hide(id)
      , @_hideDelay)

    @_count++

  hide: (id)->
    return @log('id required') unless id?

    item = @$el.find(".l-notification[data-id=\"#{id}\"]")
    return @log('item not found') unless item.length

    item.css(opacity: 0)
    window.setTimeout(=>
      item.remove()
    , @_animationDuration)
  

app.modules.Notifications = Notifications
