class Social
  render: ->
    VK.init(apiId: app.env.vk_app_id)
    VK.Widgets.Like('vk_like', 
      type: 'button'
      pageTitle: 'In 7 Seconds'
      pageDescription: 'Найди свою любовь за 7 секунд'
      pageUrl: window.location.protocol + '//' + app.env.host
      pageImage: window.location.protocol + '//' + app.env.host + '/img/avatar500.jpg'
      text: 'Анонимно найди тех, кто свободен на эту ночь. Твои друзья ни о чем не узнают, пока они тоже не заинтересованы.'
    )

    $('#vk_share').html(VK.Share.button(
      {
        title: 'In 7 Seconds'
        description: 'Найди свою любовь за 7 секунд'
        url: window.location.protocol + '//' + app.env.host
        image: window.location.protocol + '//' + app.env.host + '/img/avatar500.jpg'
        noparse: true
      }, 
      {
        type: 'button'
        text: 'Поделиться'
      }
      ))

app.modules.Social = Social
