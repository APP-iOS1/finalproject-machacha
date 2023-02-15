// const functions = require("firebase-functions");
// const admin = require("firebase-admin");
// admin.initializeApp();

// exports.machachaPushNotification = functions.firestore
//   .document("messages/{docId}")
//   .onCreate((snapshot, context) => {
//     admin.messaging().sendToTopic("notifications", {
//       notification: {
//         title: "Codeible.com",
//         body: "Notification Tutorial",
//       },
//     });
//   });

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firestore);

exports.machachaPushNotification = functions.firestore
  .document("FoodCart/{docId}")
  .onCreate((snapshot, context) => {
    const newFoodCart = snapshot.data();
    const name = newFoodCart.name;
    const region = newFoodCart.region;

    var tokenArr = [];
    admin
      .firestore()
      .collection("FCMToken")
      .get()
      .then((snapshot) => {
        snapshot.forEach((doc) => {
          tokenArr.push(doc.data().fcmToken);
        });
      })
      .catch((err) => {
        console.log("Error getting documents", err);
      });

    const payload = {
      // eslint-disable-line
      notification: {
        // eslint-disable-line
        title: "[새로운 마차챠]", // eslint-disable-line
        body: region + "에 " + name + " 등록되었습니다.", // eslint-disable-line
      }, // eslint-disable-line
      data: {
        // eslint-disable-line
        viewType: "NotificationView", // eslint-disable-line
      }, // eslint-disable-line
    }; // eslint-disable-line

    tokenArr.forEach((token) => {
      admin.messaging().sendToDevice(token, payload);
    });

    //admin.messaging().sendToTopic("notifications", {
    // notification: {
    //  title: "Codeible.com",
    //   body: "Notification Tutorial",
    // },
    // });
  });
