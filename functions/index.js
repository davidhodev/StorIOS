'use strict';
var express = require('express');
var app = express();
var bodyParser = require('body-parser');

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const logging = require('@google-cloud/logging')();
const stripe = require('stripe')('sk_test_uXJyoxDIEPUdsHXgOd2Mpj1r');
const currency = functions.config().stripe.currency || 'USD';

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
    extend : true
}));

app.post('/ephemeral_keys', (req, res) => {
    var customerId = req.body.customer_id;
    var api_version = req.body.api_version;

    stripe.ephemeralKeys.create(
        {customer : customerId},
        {stripe_version : api_version}
        ).then((key) => {
            res.status(200).send(key)
            return
    }).catch((err) => {
            console.log(err)
            res.status(500).end()

    });
});
//
// [START chargecustomer]
// Charge the Stripe customer whenever an amount is written to the Realtime database
exports.createStripeCharge = functions.database.ref('/stripe_customers/{userId}/charges/{id}')
    .onCreate((snap, context) => {
      const val = snap.val();
      // Look up the Stripe customer id written in createStripeCustomer
      return admin.database().ref(`/stripe_customers/${context.params.userId}/customer_id`)
          .once('value').then((snapshot) => {
            return snapshot.val();
          }).then((customer) => {
            // Create a charge using the pushId as the idempotency key
            // protecting against double charges
            const amount = val.amount;
            const idempotencyKey = context.params.id;
            const charge = {amount, currency, customer};
            if (val.source !== null) {
              charge.source = val.source;
            }
            return stripe.charges.create(charge, {idempotency_key: idempotencyKey});
          }).then((response) => {
            // If the result is successful, write it back to the database
            return snap.ref.set(response);
          }).catch((error) => {
            // We want to capture errors and render them in a user-friendly way, while
            // still logging an exception with StackDriver
            return snap.ref.child('error').set(userFacingMessage(error));
          }).then(() => {
            return reportError(error, {user: context.params.userId});
          });
        });
// [END chargecustomer]]


// When a user is created, register them with Stripe
exports.createStripeCustomer = functions.auth.user().onCreate((user) => {
  return stripe.customers.create({
    email: user.email,
  }).then((customer) => {
    return admin.database().ref(`/Users/${user.uid}/stripe/stripe_customer_id`).set(customer.id);
  });
});

// Add a payment source (card) for a user by writing a stripe payment source token to Realtime database
exports.addPaymentSource = functions.database
    .ref('/Users/{userId}/stripe/sources/{pushId}/token').onWrite((change, context) => {
      const source = change.after.val();
      if (source === null){
        return null;
      }
      return admin.database().ref(`/Users/${context.params.userId}/stripe/stripe_customer_id`)
          .once('value').then((snapshot) => {
            return snapshot.val();
          }).then((customer) => {
            return stripe.customers.createSource(customer, {source});
          }).then((response) => {
            return change.after.ref.parent.set(response);
          }, (error) => {
            return change.after.ref.parent.child('error').set(userFacingMessage(error));
          }).then(() => {
            return reportError(error, {user: context.params.userId});
          });
        });

exports.changePaymentSource = functions.database.ref('/Users/{userId}/stripe/defaultCard').onWrite((change, context) => {
      const source = change.after.val();
      console.log(source)
      if (source === null){
        return "hi1";
      }
      return admin.database().ref(`/Users/${context.params.userId}/stripe/stripe_customer_id`).once('value').then((snapshot) => {
        return snapshot.val();
      }).then((customer) => {
        return stripe.customers.update(customer, {default_source: source});
      }).then((response) => {
        return;
      }, (error) => {
        return change.after.ref.parent.child('error').set(userFacingMessage(error));
      }).then(() => {
        return reportError(error, {user: context.params.userId});
      });
  });


exports.deleteCard = functions.database
      .ref('/Users/{userId}/stripe/sources/{pushId}/id').onDelete((change, context) => {
        const source = change.val();
        console.log(source)
        if (source === null){
          return "hi1";
        }
        return admin.database().ref(`/Users/${context.params.userId}/stripe/stripe_customer_id`).once('value').then((snapshot) => {
          return snapshot.val();
        }).then((customer) => {
          console.log(customer)
          return stripe.customers.deleteCard(customer, source);
        }).then((response) => {
          return;
        }, (error) => {
          return;
        }).then(() => {
          console.log(error);
          return;
        });
    });
        //   // Attach an asynchronous callback to read the data at our posts reference
        //   ref.on("value", function(snapshot) {
        //     console.log(snapshot.val());
        //     cardID = snapshot.val();
        //   }, function (errorObject) {
        //     console.log("The read failed: " + errorObject.code);
        //   });
        //   return admin.database().ref(`/Users/${event.params.userId}/stripe/stripe_customer_id`).once('value').then(snapshot => {
        //     return snapshot.val();
        //   }).then(customer => {
        //     return stripe.customers.update(customer, {default_source: cardID});
        //   }).then(response => {
        //       return event.data.adminRef.parent.set(response);
        //     }, error => {
        //       return event.data.adminRef.parent.child('error').set(userFacingMessage(error)).then(() => {
        //         // return reportError(error, {user: event.params.userId});
        //         consolg.log(error, {user: event.params.userId});
        //       });
        //   });
        // });
        // stripe.customers.update('cus_V9T7vofUbZMqpv', {
        //   source: 'tok_visa',
        // });



// exports.addPaymentSource = functions.database
//     .ref('/Users/{user.uid}/stripe/sources/{pushID}/token').onWrite((change, context) => {
//       const source = change.after.val();
//       if (source === null){
//         return null;
//       }
//       return admin.database().ref(`/Users/${context.params.userId}/stripe/stripe_customer_id`)//`/stripe_customers/${context.params.userId}/customer_id`)
//           .once('value').then((snapshot) => {
//             return snapshot.val();
//           }).then((customer) => {
//             return stripe.customers.createSource(customer, {source});
//           }).then((response) => {
//             return change.after.ref.parent.set(response);
//           }, (error) => {
//             return change.after.ref.parent.child('error').set(userFacingMessage(error));
//           }).then(() => {
//             return reportError(error, {user: context.params.userId});
//           });
//         });

// When a user deletes their account, clean up after them
exports.cleanupUser = functions.auth.user().onDelete((user) => {
  return admin.database().ref(`/stripe_customers/${user.uid}`).once('value').then(
      (snapshot) => {
        return snapshot.val();
      }).then((customer) => {
        return stripe.customers.del(customer.customer_id);
      }).then(() => {
        return admin.database().ref(`/stripe_customers/${user.uid}`).remove();
      });
    });


// When a user is created, register them with Stripe
// exports.createStripeCustomer = functions.auth.user().onCreate((user) => {
//   return stripe.customers.create({
//     email: user.email,
//   }).then((customer) => {
//     return admin.database().ref(`/Users/${user.uid}/stripe/stripe_customer_id`).set(customer.id);
//   });
// });
//
// // Add a payment source (card) for a user by writing a stripe payment source token to Realtime database
// exports.addPaymentSource = functions.database
//     .ref('/Users/{user.uid}/stripe/sources/{pushId}/token').onWrite((change, context) => {
//       const source = change.after.val();
//       if (source === null){
//         return null;
//       }
//       return admin.database().ref(`/Users/s${context.params.userId}/stripe/stripe_customer_id`)
//           .once('value').then((snapshot) => {
//             return snapshot.val();
//           }).then((customer) => {
//             return stripe.customers.createSource(customer, {source});
//           }).then((response) => {
//             return change.after.ref.parent.set(response);
//           }, (error) => {
//             return change.after.ref.parent.child('error').set(userFacingMessage(error));
//           }).then(() => {
//             return reportError(error, {user: context.params.userId});
//           });
//         });
//
// // When a user deletes their account, clean up after them
// exports.cleanupUser = functions.auth.user().onDelete((user) => {
//   return admin.database().ref(`/stripe_customers/${user.uid}`).once('value').then(
//       (snapshot) => {
//         return snapshot.val();
//       }).then((customer) => {
//         return stripe.customers.del(customer.customer_id);
//       }).then(() => {
//         return admin.database().ref(`/stripe_customers/${user.uid}`).remove();
//       });
//     });

// To keep on top of errors, we should raise a verbose error report with Stackdriver rather
// than simply relying on console.error. This will calculate users affected + send you email
// alerts, if you've opted into receiving them.
// [START reporterror]
function reportError(err, context = {}) {
  // This is the name of the StackDriver log stream that will receive the log
  // entry. This name can be any valid log stream name, but must contain "err"
  // in order for the error to be picked up by StackDriver Error Reporting.
  const logName = 'errors';
  const log = logging.log(logName);

  // https://cloud.google.com/logging/docs/api/ref_v2beta1/rest/v2beta1/MonitoredResource
  const metadata = {
    resource: {
      type: 'cloud_function',
      labels: {function_name: process.env.FUNCTION_NAME},
    },
  };

  // https://cloud.google.com/error-reporting/reference/rest/v1beta1/ErrorEvent
  const errorEvent = {
    message: err.stack,
    serviceContext: {
      service: process.env.FUNCTION_NAME,
      resourceType: 'cloud_function',
    },
    context: context,
  };

  // Write the error log entry
  return new Promise((resolve, reject) => {
    log.write(log.entry(metadata, errorEvent), (error) => {
      if (error) {
       return reject(error);
      }
      return resolve();
    });
  });
}
// [END reporterror]

// Sanitize the error message for the user
function userFacingMessage(error) {
  return error.type ? error.message : 'An error occurred, developers have been alerted';
}

// Old Code

// Prints a string to link
exports.helloWorld = functions.https.onRequest((request, response) => {
  response.send("Hello my name is David Ho! Firebase Cloud Functions");
});

// Triggers on Listen

// Take the text parameter passed to this HTTP endpoint and insert it into the
// Realtime Database under the path /messages/:pushId/original
exports.addMessage = functions.https.onRequest((req, res) => {
  // Grab the text parameter.
  const original = req.query.text;
  // Push the new message into the Realtime Database using the Firebase Admin SDK.
  return admin.database().ref('/messages').push({original: original}).then((snapshot) => {
    // Redirect with 303 SEE OTHER to the URL of the pushed object in the Firebase console.
    return res.redirect(303, snapshot.ref.toString());
  });
});

// Listens for new messages added to /messages/:pushId/original and creates an
// uppercase version of the message to /messages/:pushId/uppercase
exports.makeUppercase = functions.database.ref('/messages/{pushId}/original')
    .onCreate((snapshot, context) => {
      // Grab the current value of what was written to the Realtime Database.
      const original = snapshot.val();
      console.log('Uppercasing', context.params.pushId, original);
      const uppercase = original.toUpperCase();
      // You must return a Promise when performing asynchronous tasks inside a Functions such as
      // writing to the Firebase Realtime Database.
      // Setting an "uppercase" sibling in the Realtime Database returns a Promise.
      return snapshot.ref.parent.child('uppercase').set(uppercase);
    });
