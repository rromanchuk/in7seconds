# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require ./vendor/jquery
#= require ./vendor/lodash.underscore
#= require ./vendor/backbone

#= require_tree ./vendor/plugins
#= require ./app.utils

app = _.extend(@app, Backbone.Events)

# Manage HTML classes
app.dom.html.removeClass('no-js').addClass('js')
app.dom.html.addClass('opera')                                   if app.browser.isOpera
app.dom.html.addClass('firefox')                                 if app.browser.isFirefox
app.dom.html.addClass('ie ie' + app.browser.isIE)                if app.browser.isIE
app.dom.html.addClass('ios ios' + app.browser.isIOS)             if app.browser.isIOS
app.dom.html.addClass('android android' + app.browser.isAndroid) if app.browser.isAndroid

# Modules
# app.settings = new app.modules.Settings(app.settings)
# app.analytics = new app.modules.Analytics()
# app.notifications = new app.modules.Notifications()

# if app.user
#   app.header = new app.modules.Header()

# app.size = new app.modules.Size()
# app.social = new app.modules.Social()

# Fire up the router
Backbone.history.start(pushState: true)

# app.linksManager = new app.modules.LinksManager()

app.log('[app]: initialize')

@app = app
