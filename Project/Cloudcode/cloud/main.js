/*
Created by Mikael Melander 2016-03-24

CloudCode functions
 */

 /*
Before anything is saved in ChatRooms this script is executed.

Set of basic colors a room can be set to.

Querys the latest room and fetches its color.

Compares it to the random color the room will be assigned.
If they are the same, gets a new random color until they are diffrent.
So rooms that are next to each other cant be the same color. I mean how ugly? :P
 */
Parse.Cloud.beforeSave("ChatRooms", function(request, response) {

    Parse.Cloud.useMasterKey();
    var colors = ["#2ecc71", "#3498db", "#9b59b6", "#34495e","#1abc9c", "#e67e22","#ea6153", "#7f8c8d"];
    var numb = Math.floor((Math.random() * colors.length));
    var color = colors[numb];

    var Ca = Parse.Object.extend("ChatRooms");
    var ca = new Ca();
    var query = new Parse.Query(ca);
    query.descending("createdAt");
    query.limit(1);
    query.find({
        success:function(object){


            var prev = object[0].get("color");

            while (prev == color) {
                numb = Math.floor((Math.random() * colors.length));
                color = colors[numb];
            }
                request.object.set("color", color);
                response.success();



        },error:function(){
            response.error(error);
        }

    });

});

Parse.Cloud.define("licensText", function(request, response) {

   // var textLicens = "When using this application you are not allowed to use foul language, you need to follow the law, not post copyrighted material.\nShow each other respect.  \nYou also agree that we store your name in a remote database.\n\nCreated by Mikael Melander for Linnaeus university Course 1DV430";

    var textLicens = "More text to come...\nYou agree that we store your name in a remote database. According to PUL \n\nCreated by Mikael Melander for Linnaeus university Course 1DV430";
    response.success(textLicens);
});

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

       var patt = new RegExp("@student.lnu.se");
       var res = patt.test(email);

      //This is just a string in the users data. It makes it easier and faster for the client side to check privligaes.
      //If user has @student.lnu.se email gives "standard role"
      if (res)
      user.set("role", "User");
      //If user has @lnu.se email give admin rights
      if (!res)
      user.set("role","Administrator");

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
 /* var mandrill = require("mandrill");
  mandrill.initialize("LwKRMxkdNGzYZgUIAws2rg");

  var body = 'Your account information for LnuChat application \n\n' + 'Your username: ' + emailadress + '\nTemporary password: ' + password + '\n\n(PS! Both username and password are capslock sensitive) \n\nBest regards LnuChat';
  var title = 'LnuChat Account information.';
  var from_email = 'noreply@lnuchat.se';
  var from_name = "LnuChat";

  mandrill.sendEmail({
        message: {
          text: body,
          subject: title,
          from_email: from_email,
          from_name: from_name,
          to: [
            {
              email: emailadress
            }
          ]
        },
        async: false
      },
      {
        success: function(httpResponse) {
          return "Successfully created user. An email has been sent.";
        },
        error: function(error) {
          return "Something went wrong. Could not create user :(";
        }
      }); */
      
    var body = 'Your account information for LnuChat application \n\n' + 'Your username: ' + emailadress + '\nTemporary password: ' + password + '\n\n(PS! Both username and password are capslock sensitive) \n\nBest regards LnuChat';
    var title = 'LnuChat Account information.';
      
    var mailgun = require('mailgun');
    mailgun.initialize('mg.swift-it.se', 'key-2c1f928bae591827096c3b2abcddad53');

    
    mailgun.sendEmail({
        to: emailadress,
        from: 'LnuChat <noreply@lnuchat.se>',
        subject: title,
        text: body
    }, {
        success: function(httpResponse) {
            console.log(httpResponse);
            response.success("Your mail has been sent to support");
        },
        error: function(httpResponse) {
            console.error(httpResponse);
            response.error("Something went wrong, the mail has not been sent :(");
        }
    });
}

Parse.Cloud.afterSave("Conversations", function(request) {

    if (!request.object.get("Edited") == true) {
    var query = new Parse.Query(Parse.Installation);
    //Dont want the author to get its on message, because its already added locally
    query.notEqualTo("Username", Parse.User.current().get("username"));

    Parse.Push.send({
        where: query,
        data: {
            chatId: request.object.id,
            objectId: request.object.get("ChatRoom").id,
            tag: "update"
        }
    }, {
        success: function () {

        }, error: function (error) {
            console.log(error);
        }
    });
    }

    if(request.object.get("TaggedUsers").length > 0) {

        var query2 = new Parse.Query(Parse.Installation);

        //Dont want the author to get its on message, because its already added locally
        query2.notEqualTo("Username", Parse.User.current().get("username"));
        query2.containedIn("Username", request.object.get("TaggedUsers"));
       
        Parse.Push.send({
            where: query2,
            data: {
                alert: Parse.User.current().get("name")+ ": " + request.object.get("Message"),
                message: Parse.User.current().get("name")+ ": " + request.object.get("Message"),
                chatId: request.object.id,
                objectId: request.object.get("ChatRoom").id,
                badge: "Increment",
                sound: "cheering.caf",
                tag: "mentioned"
            }
        }, {
            success: function () {

            }, error: function (error) {
                console.log(error);
            }
        });
    }

});


Parse.Cloud.define("CreateRoom", function(request, response) {

    var Room = Parse.Object.extend("ChatRooms");
    var room = new Room();

    room.set("RoomName", request.params.Roomname);
    room.set("RoomDescription", request.params.RoomDetails);
    room.set("CreatedBy", Parse.User.current());

    /* SETTING UPP ACL FOR ROOM */
    var acl = new Parse.ACL();
    acl.setPublicReadAccess(false);
    acl.setPublicWriteAccess(false);
    acl.setRoleReadAccess("User", true);
    acl.setRoleReadAccess("Administrator", true);
    acl.setRoleWriteAccess("Administrator", true);
    room.setACL(acl);

    room.save(null, {
        success: function() {
            response.success("Rummet har blivit skapat");
        },
        error: function(error) {
            response.error(error);
        }
    });

});



