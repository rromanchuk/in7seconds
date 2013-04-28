
Starting Rails and Faye
======
 foreman start
 

Testing emails
======
1. setup app/mailers/mail_preview.rb
2. http://localhost:3000/mail_view/welcome

Api
======

GET `http://in7secondsdev.com:3000/users/authenticated_user.json?auth_token=2E79U7nCUFBnoqH8Ldav`

```json
{
   id:767488622,
   vk_token:"9d6d6388e499f53227009db7ed9526762fd6f7fea9388fbf13cb34a08a5302b8c1887879e88542eed0860",
   fb_token:"",
   authentication_token:"2E79U7nCUFBnoqH8Ldav",
   updated_at:"2013-04-28T09:50:53Z",
   first_name:"Ryan",
   last_name:"Romanchuk",
   gender:false,
   looking_for_gender:0,
   email:"rromanchuk@gmail.com",
   photo_url:"http://cs9609.vk.me/u41526347/a_b9a69665.jpg",
   country:"USA",
   city:"San Francisco",
   vk_domain:null,
   birthday:"",
   images:[
      {
         id:1,
         photo_url:"http://s3.amazonaws.com/ostronaut-dev/development/users/images/1/default/my_photo.jpg?1367139862",
         created_at:"2013-04-28T09:04:22Z"
      },
      {
         id:2,
         photo_url:"http://s3.amazonaws.com/ostronaut-dev/development/users/images/2/default/my_photo.jpg?1367140937",
         created_at:"2013-04-28T09:22:18Z"
      }
   ]
}
```
