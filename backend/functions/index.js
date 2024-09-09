const functions = require("firebase-functions");

const admin = require("firebase-admin");

var serviceAccount = require("./key.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const express = require("express");
const cors = require("cors");
// const { response } = require("express");
const app = express();


const { FieldValue } = require('firebase-admin/firestore')

// Parse JSON request bodies
app.use(express.json());

app.use(cors({ origin: true }));
const db = admin.firestore();
// const { db } = require('./firebase.js')
// Routes
app.get("/", (req, res) => {
  return res.status(200).send("Hello Pancar here");
});
// create
// Post
app.post("/api/create", (req, res) => {
  (async () => {
    try {
        const { title, description, date, location, organizer, eventType } = req.body;

        // Log the request body for debugging
        // console.log(req.body);

        // Validate the request body fields
        if (!title || !description || !date || !location || !organizer || !eventType) {
            return res.status(400).json({ error: 'Missing required fields' });
        }
      await db.collection("eventdetails").doc(`/${Date.now()}/`).create({
        title: title,
        description: description,
        date: date,
        location: location,
        organizer: organizer,
        eventType: eventType,
        updatedAt: new Date().toISOString()  // Automatically set updatedAt to the current time
      });

      return res.status(200).send({ status: "Success", msg: "Data Saved" });
    } catch (error) {
      console.log(error);
      res.status(500).send({ status: "Failed", msg: error });
    }
  })();
});

// read specific user detail
// get
app.get("/api/eventDetail/:id", (req, res) => {
  (async () => {
    try {
      const reqDoc = db.collection("eventdetails").doc(req.params.id);
      let eventDetail = await reqDoc.get();
      let response = eventDetail.data();

      return res.status(200).send({ status: "Success", data: response });
    } catch (error) {
      console.log(error);
      res.status(500).send({ status: "Failed", msg: error });
    }
  })();
});

// read all user details
// get
app.get("/api/events", (req, res) => {
  (async () => {
    try {
      let query = db.collection("eventdetails");
      let response = [];

      await query.get().then((data) => {
        let docs = data.docs; // query results

        docs.map((doc) => {
          const input = doc.data();
          const selectedData = {
            title: input.title,
            description: input.description,
            date: input.date,
            location: input.location,
            organizer: input.organizer,
            eventType: input.eventType,
            updatedAt: input.updatedAt
          };

          response.push(selectedData);
        });
        return response;
      });

      return res.status(200).send({ status: "Success", data: response });
    } catch (error) {
      console.log(error);
      res.status(500).send({ status: "Failed", msg: error });
    }
  })();
});

// update
// put
app.put("/api/update/:id", (req, res) => {
  (async () => {
    try {
      const reqDoc = db.collection("eventdetails").doc(req.params.id);
      await reqDoc.update({
        name: req.body.name,
        mobile: req.body.mobile,
        address: req.body.address,
      });
      return res.status(200).send({ status: "Success", msg: "Data Updated" });
    } catch (error) {
      console.log(error);
      res.status(500).send({ status: "Failed", msg: error });
    }
  })();
});

// delete
// delete
app.delete("/api/delete/:id", (req, res) => {
  (async () => {
    try {
      const reqDoc = db.collection("eventdetails").doc(req.params.id);
      await reqDoc.delete();
      return res.status(200).send({ status: "Success", msg: "Data Removed" });
    } catch (error) {
      console.log(error);
      res.status(500).send({ status: "Failed", msg: error });
    }
  })();
});

// Exports api to the firebase cloud functions
exports.app = functions.https.onRequest(app);