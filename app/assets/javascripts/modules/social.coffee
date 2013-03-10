class Social
  render: ->
    VK.init(apiId: app.env.vk_id)
    VK.Widgets.Like('vk_like', 
      type: 'button'
      pageTitle: 'FuckWithFriends.ru'
      pageDescription: 'Открой своих друзей с новой стороны'
      pageUrl: window.location.protocol + '//' + app.env.host
      pageImage: window.location.protocol + '//' + app.env.host + '/img/couple1.jpg'
      text: 'Анонимно найди тех, кто свободен на эту ночь. Твои друзья ни о чем не узнают, пока они тоже не заинтересованы.'
    )

    $('#vk_share').html(VK.Share.button(
      {
        title: 'FuckWithFriends.ru'
        description: 'Открой своих друзей с новой стороны'
        url: window.location.protocol + '//' + app.env.host
        image: window.location.protocol + '//' + app.env.host + '/img/couple1.jpg'
        noparse: true
      }, 
      {
        type: 'button'
        text: 'Поделиться'
      }
      ))

app.modules.Social = Social
