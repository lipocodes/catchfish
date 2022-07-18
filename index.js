const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);
let message = {};
let body = "";
let id="";
let updatedCaughtFish = [];

exports.detectPriceOffersFishPersonalCollection = functions.firestore
    .document("users/{docId}")
    .onUpdate((change, context) => {
      const newPriceOfferFishPersonalCollection =
          change.after.data()["newPriceOfferFishPersonalCollection"];
      const FCMToken = change.after.data()["FCMToken"];
      const docID = change.after.data()["docID"];  
      if (newPriceOfferFishPersonalCollection==true) {
        senNotNewPriceOffer(FCMToken);
        const prefix = admin.firestore().collection("users").doc(docID);
        prefix.update({newPriceOfferFishPersonalCollection: false});
      }
    });

const senNotNewPriceOffer = function sendNotification(FCMToken) {
  body = "You have  a new price offer for fish in your Private Collection.";
  message = {
    notification: {
      title: "CatchFish app:",
      body: body,
    },
    token: FCMToken,
  };
  admin.messaging().send(message);
};
exports.senNotNewPriceOffer = senNotNewPriceOffer;


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
functions.pubsub.schedule("every 1 hours").onRun((context) => {
  admin.firestore().collection("users").get()
      .then(function(querySnapshot) {
        // going over each doc (a user) in col "users"
        querySnapshot.forEach((subDoc) => {
          let sentNotificationYet=false;
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
            if (now-timeCaughtFish<(4*3600*1000) &&
            now-timeCaughtFish>(3*3600*1000)) {
              if (sentNotificationYet==false) {
                sentNotificationYet=true;
                senNot(FCMToken, 4);
              }
            } else if (now-timeCaughtFish<(12*3600*1000) &&
            now-timeCaughtFish>(11*3600*1000)) {
              if (sentNotificationYet==false) {
                sentNotificationYet=true;
                senNot(FCMToken, 12);
              }
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
      });
});
