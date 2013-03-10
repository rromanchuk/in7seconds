class Settings
  trace: app.env.debug
  logPrefix: '[app.modules.Settings]:'
  log: Spine.Log.log

  constructor: (@settings)->
    @log('initialized with settings', @settings)

  set: (key, value)->
    @settings[key] = value

  get: (key)->
    @settings[key]
    
  save: (callback)=>
    $.ajax(
      url: app.api('settings')
      type: 'PUT'
      data: @settings
      success: =>
        callback?()
        @log('settings saved')
      )

app.modules.Settings = Settings
