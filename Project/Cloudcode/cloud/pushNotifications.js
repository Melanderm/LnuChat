/*
After a message is saved to de databse
notify users
*/
Parse.Cloud.afterSave("Conversations", function(request) {
    // Dont want users to get notified of edited messages
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

    // If user is tagged in the message
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
