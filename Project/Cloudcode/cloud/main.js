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
require('pushNotifications.js');
require('users.js');

// On created chatrooms
Parse.Cloud.beforeSave("ChatRooms", function(request, response) {
    if (!request.object.existed()) {
        Parse.Cloud.useMasterKey();
        var colors = ["#2ecc71", "#3498db", "#9b59b6", "#34495e", "#1abc9c", "#e67e22", "#ea6153", "#7f8c8d"];
        var num = Math.floor((Math.random() * colors.length));
        var color = colors[num];

        var Ca = Parse.Object.extend("ChatRooms");
        var ca = new Ca();
        var query = new Parse.Query(ca);
        query.descending("createdAt");
        query.limit(1);
        // Checking colors of last created room, to not have 2 rooms next to each other with same color.
        query.find({
            success: function (object) {
                var prev = object[0].get("color");
                while (prev == color) {
                    numb = Math.floor((Math.random() * colors.length));
                    color = colors[numb];
                }
                request.object.set("color", color);
                response.success();


            }, error: function () {
                response.error(error);
            }

        });
    } else
        response.success();
});


// Adding licens agreement for it to easily be changed.
Parse.Cloud.define("licensText", function(request, response) {
    var textLicens = "More text to come...\nYou agree that we store your name in a remote database. According to PUL \n\nCreated by Mikael Melander for Linnaeus university Course 1DV430";
    response.success(textLicens);
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
    acl.setRoleReadAccess("MasterAdministrator", true);
    acl.setRoleWriteAccess("MasterAdministrator", true);

    // Setting AccessControl list for private rooms.
    if (typeof request.params.InvitedUsers != "undefined") {
    	    	for (var i=0; i<request.params.InvitedUsers.length; i++) {
    	    	    	  acl.setReadAccess(request.params.InvitedUsers[i], true);
    	         }
            var NewArray = request.params.InvitedUsers.slice();
            NewArray.push(Parse.User.current().id);
    	    room.set("Private", true);
    	    room.set("Users", NewArray);
    	    acl.setReadAccess(Parse.User.current(), true);
    	    acl.setRoleReadAccess("Administrator", false); // Admins should not have access to private rooms.
    	    acl.setRoleWriteAccess("Administrator", false);
    	    room.setACL(acl);
    	}
    	else
    	{
      // IF not a private room, set standard acl.
    	room.set("Private", false);
 	    acl.setRoleReadAccess("User", true);
 	    acl.setRoleReadAccess("Administrator", true);
    	acl.setRoleWriteAccess("Administrator", true);
   	  room.setACL(acl);
    }


    room.save(null, {
        success: function() {
            response.success("Rummet har blivit skapat");

          // IF private room. Send invitation notifications to users.
           if (typeof request.params.InvitedUsernames != "undefined") {
           var query = new Parse.Query(Parse.Installation);
           query.notEqualTo("Username", Parse.User.current().get("username"));
           query.containedIn("Username", request.params.InvitedUsernames);

            Parse.Push.send({
            where: query,
            data: {
                alert: Parse.User.current().get("name") + " har bjudit in dig till ett nytt rum!",
                badge: "Increment",
                sound: "cheering.caf",
                tag: "newRoom"
            }
        }, {
            success: function () {

            }, error: function (error) {
                console.log(error);
            }
        });
             }
        },
        error: function(error) {
            response.error(error);
        }
    });

});

Parse.Cloud.define("InviteUser", function(request, response) {
    Parse.Cloud.useMasterKey();
    var room;
    var ChatRoom = Parse.Object.extend("ChatRooms");
    var query = new Parse.Query(ChatRoom);
    query.equalTo("objectId", request.params.roomID);
    query.first({
        success: function (object) {
          room = object;
        }
    }).then(function () {
        /* SETTING UPP ACL FOR ROOM */
        var acl = room.getACL();
        var roomusers = room.get("Users");


        for (var a = 0; a < request.params.InvitedUsers.length; a++) {
            roomusers.push(request.params.InvitedUsers[a]);
            acl.setReadAccess(request.params.InvitedUsers[a], true);
        }

            room.set("Users", roomusers);
            room.setACL(acl);


        room.save(null, {
            success: function () {
                response.success("Inbjudan har genomförts");

                    var query = new Parse.Query(Parse.Installation);
                    query.notEqualTo("Username", Parse.User.current().get("username"));
                    query.containedIn("Username", request.params.InvitedUsernames);

                    Parse.Push.send({
                        where: query,
                        data: {
                            alert: Parse.User.current().get("name") + " har bjudit in dig till ett privat rum!",
                            badge: "Increment",
                            sound: "cheering.caf",
                            tag: "newRoom"
                        }
                    }, {
                        success: function () {

                        }, error: function (error) {
                            console.log(error);
                        }
                    });
            },
            error: function (error) {
                response.error(error);
            }
        });
    });
});
