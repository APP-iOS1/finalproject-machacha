const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.machachaPushNotification = functions.firestore
  .document("messages/{docId}")
  .onCreate((snapshot, context) => {
    admin.messaging().sendToTopic("notifications", {
      notification: {
        title: "Codeible.com",
        body: "Notification Tutorial",
      },
    });
  });
