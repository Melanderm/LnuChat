/*
Creates user object
And sets upp roles

 */
Parse.Cloud.define("createUser", function(request, response) {

      Parse.Cloud.useMasterKey(); //USING MASTER KEY TO BE ALBE TO SET UP ROLE
      var email = request.params.email;
      var password = randomP(); //Random generated temporary password.
      var user = new Parse.User();

      user.set("username", email);
      user.set("mail", email);
      user.set("password", password);
      user.set("changepassword", true); //Sets up user first time login changing from temporary password.
      user.set("reciveTag", true);

       var patt = new RegExp("@lnu.se");
       var res = patt.test(email);

      //This is just a string in the users data. It makes it easier and faster for the client side to check privligaes.
      //If user has @student.lnu.se email gives "standard role" => User
      if (res)
      //If user has @lnu.se email give admin rights
      user.set("role", "Administrator");
      else
      user.set("role","User");

      Parse.Object.saveAll(user).then(function () {
      }, function(error) {
        response.error(error);
      }).then(function () {
        var userobject;
        var query2 = new Parse.Query(Parse.User);
        query2.equalTo("username", email);
        query2.first({
          success: function (user) {
            userobject = user;
          }
        }).then(function () {
            //Assigns the role.
            //This really creates the rights the user has.
          query = new Parse.Query(Parse.Role);
          if (res)
            query.equalTo("name", "User");
          if (!res)
            query.equalTo("name", "Administrator");

          query.first().then(function (object) {
            object.relation("users").add(userobject);
            object.save();
            response.success(emailAdress(email, password)); //Calls email to be sent with the login information.
          })
        });
      })

});

/*
Creates a random temporary password by slicing a random string.
 */
function randomP() {
  var randomstring = Math.random().toString(36).slice(-8);
  return  (randomstring);
}

/*
Sending information email when user has been created.
*/
function emailAdress(emailadress, password) {
    var body = 'Your account information for LnuChat application \n\n' + 'Your username: ' + emailadress + '\nTemporary password: ' + password + '\n\n(PS! Both username and password are capslock sensitive) \n\nBest regards LnuChat';
    var title = 'LnuChat Account information.';

    var mailgun = require('mailgun');
    mailgun.initialize('mg.swift-it.se', '_MAILGUN_ID');


    mailgun.sendEmail({
        to: emailadress,
        from: 'LnuChat <noreply@lnuchat.se>',
        subject: title,
        text: body
    }, {
        success: function(httpResponse) {
            console.log(httpResponse);
            response.success("Your mail has been");
        },
        error: function(httpResponse) {
            console.error(httpResponse);
            response.error("Something went wrong, the mail has not been sent :(");
        }
    });
}
