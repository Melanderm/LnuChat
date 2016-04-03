/*
Created by Mikael Melander 2016-03-24

CloudCode functions
 */


Parse.Cloud.define("licensText", function(request, response) {

    var textLicens = "When using this application you are not allowed to use foul language, you need to follow the law, not post copyrighted material.\nShow each other respect.  \nYou also agree that we store your name in a remote database.\n\nCreated by Mikael Melander for Linnaeus university Course 1DV430";

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
    var mandrill = require("mandrill");
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
        });
}