User = Backbone.Model.extend
  defaults:
    id: null

    first_name: null
    last_name: null

    birthday: null
    gender: null

    email: null
    photo_url: null

    country: null
    city: null

    vk_domain: null
    vk_university_name: null
    vk_graduation: null
    vk_faculty_name: null

  loaded: ->
    !!@get('id')

app.models.User = User
