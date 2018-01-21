const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
const ref = admin.database().ref();
const dbPostsRef = ref.child("posts");
const dbUsersRef = ref.child("users");

exports.addNewUsersToDatabase = functions.auth.user().onCreate(event => {
    const user = event.data;
    
    let email = user.email || null;
    let username = user.displayName || null;
    let uid = user.uid;
    let provider = user.providerData ? user.providerData[0] : null;
    let signUpDate = (new Date()).toJSON();

    const userData = {
        username: email,
        email: email,
        provider: provider,
        signUpDate: signUpDate
    }

    // const createUserData = {
    //     userId: uid
    // }
    
    // var jsonData = JSON.stringify(createUserData);    
    // let url = "http://54.89.180.9:8080/createUser";
    // request.post({
    // url: url,
    // body: jsonData
    // }, function(error, response, body) {
    // if (error) {
    // } else {
    //     var jsonResponse = JSON.parse(body);
    //     if (jsonResponse.status === 0) {
    //     console.log('Valid!');
    //     } else {
    //     console.log('Invalid!.');
    //     }
    //     console.log('Done.');
    // }
    // });

    const newUserRef = ref.child(`/users/${uid}`);
    return newUserRef.set(userData);

});