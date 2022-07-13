const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);
let message = {};
let body = "";
let id="";
let updatedCaughtFish = [];

const senNot = function sendNotification(FCMToken, hoursToDeletion) {
  body = "You have " + hoursToDeletion.toString();
  body+=" hours left to sell your fish!";
  message = {
    notification: {
      title: "CatchFish app:",
      body: body,
    },
    token: FCMToken,
  };
  admin.messaging().send(message);
};

exports.senNot = senNot;

exports.scheduledFunctionPlainEnglish =
functions.pubsub.schedule("every 2 minutes").onRun((context) => {
  admin.firestore().collection("users").get()
      .then(function(querySnapshot) {
        // going over each doc (a user) in col "users"
        querySnapshot.forEach((subDoc) => {
          id="";
          updatedCaughtFish=[];
          const FCMToken = subDoc.data()["FCMToken"];
          id = subDoc.id;
          const caughtFish = subDoc.data()["caughtFish"];
          // going over each string (fish) in array caughtFish
          caughtFish.forEach((fish) => {
            const now = Date.now();
            const arr = fish.split("^^^");
            const timeCaughtFish = arr[5];
            if (now-timeCaughtFish<(12*3600*1000) &&
            now-timeCaughtFish>(11*3600*1000)) {
              senNot(FCMToken, 12);
            } else if (now-timeCaughtFish<(4*3600*1000) &&
            now-timeCaughtFish>(3*3600*1000)) {
              senNot(FCMToken, 4);
            }
            if (now-timeCaughtFish<(24*3600*1000)) {
              updatedCaughtFish.push(fish);
            }
          });
          // now we have an updated caughtFish array we
          // need to update caughtFish array of this userAgent
          const prefix = admin.firestore().collection("users").doc(id);
          prefix.update({caughtFish: updatedCaughtFish});
        });
        const size = querySnapshot.size;
        console.log("cccccccccccccccc=" + size);
      });
});
