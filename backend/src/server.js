const express = require('express')
const { FieldValue } = require('firebase-admin/firestore');
const errors = require("./middleware/errors.js");

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const cors = require("cors");

const app = express();
const port = process.env.PORT || 8383;
const { db } = require('../firebase.js');
app.use(cors({ origin: true }));
app.use(express.json());
app.use(errors.errorHandler);

app.get('/events', async (req, res) => {
    try {
        const eventsRef = db.collection('event'); // Reference to the 'event' collection
        const snapshot = await eventsRef.get(); // Get all documents in the collection
        if (!snapshot.exists) {
            return res.status(404).send({ error: 'No matching data found' });
        }
        // Map through the snapshot to extract the data from each document
        const events = snapshot.docs.map(doc => ({
            id: doc.id, // Optionally include document ID
            ...doc.data() // Spread operator to get all fields in the document
        }));

        res.status(200).json(events); // Send all events as JSON response
    } catch (error) {
        console.error('Error getting documents', error);
        res.status(500).send('Error retrieving events');
    }
})

app.post('/events/addEvent', async (req, res) => {
    try {
        // Destructure all fields from the request body
        const { title, description, date, location, organizer, eventType, updatedAt } = req.body;

        // Log the incoming request for debugging purposes
        
        console.log(title, description, date, location, organizer, eventType);
        // Generate a unique key using the current timestamp
        const timestamp = new Date().getTime().toString(); // Convert to string if needed

        const eventRef = db.collection('event').doc(timestamp);

        // Set the data in Firestore (using merge: true in case you want to preserve other fields)
        const res2 = await eventRef.set({
            title: title,
            description: description,
            date: date,
            location: location,
            organizer: organizer,
            eventType: eventType,
            updatedAt: new Date().toISOString()  // Automatically set updatedAt to the current time
        }, { merge: true });

        // Return a success response
        res.status(200).json({ message: 'Event added successfully', data: req.body });
    } catch (error) {
        console.error('Error adding event:', error);
        res.status(500).json({ error: 'An error occurred while adding the event' });
    }
})

// update
app.put("/events/:id", (req, res) => {// app.patch
  (async () => {
    try {
      const reqDoc = db.collection("event").doc(req.params.id);
      const { title, description, date, location, organizer, eventType } = req.body;
      // Validate the request body fields
    //   if (!title || !description || !date || !location || !organizer || !eventType) {
    //       return res.status(400).json({ error: 'Missing required fields' });
    //   }

      await reqDoc.update({
        title: title,
        description: description,
        date: date,
        location: location,
        organizer: organizer,
        eventType: eventType,
        updatedAt: new Date().toISOString()  // Automatically set updatedAt to the current time
      });
      return res.status(200).send({ status: "Success", msg: "Data Updated" });
    } catch (error) {
      console.log(error);
      res.status(500).send({ status: "Failed", msg: error });
    }
  })();
});


app.delete('/events', async (req, res) => {
    const { id } = req.body; 
    console.log('XDDDDDDDDDDDDDD');
    
    console.log(id);
    
    const eventRef = db.collection('event').doc(id); // Reference to the document to delete
    const snapshot = await eventRef.get(); // Get all documents in the collection
    // if (!snapshot.exists) {
    //     return res.status(404).send({ error: 'There is matching data' });
    // }
    // await eventRef.delete();
    res.status(200).send({ message: 'Event deleted successfully' }); // Send a success message
})

app.delete("/events/:id", (req, res) => {
  (async () => {
    try {
        const eventRef = db.collection("event").doc(req.params.id);
        const snapshot = await eventRef.get(); // Get all documents in the collection
        if (!snapshot.exists) {
            return res.status(404).send({ error: 'No matching data found for the provided ID' });
        }
        await eventRef.delete();
        return res.status(200).send({ status: "Success", msg: "Data Removed" });
    } catch (error) {
        console.log(error);
        res.status(500).send({ status: "Failed", msg: error });
    }
  })();
});

app.listen(port, () => console.log(`Server has started on port: ${port}`));
// Exports api to the firebase cloud functions
exports.app = functions.https.onRequest(app);

// const {Server} = require('ws');

// const PORT = process.env.PORT || 8383;

// const db = admin.firestore();
// // Routes
// app.get("/", (req, res) => {
//   return res.status(200).send("Hello Pancar here");
// });
// // create
// // Post
// app.post("/api/create", (req, res) => {
//   (async () => {
//     try {
//         const { title, description, date, location, organizer, eventType } = req.body;

//         // Log the request body for debugging
//         // console.log(req.body);

//         // Validate the request body fields
//         if (!title || !description || !date || !location || !organizer || !eventType) {
//             return res.status(400).json({ error: 'Missing required fields' });
//         }
//       await db.collection("event").doc(`/${Date.now()}/`).create({
//         title: title,
//         description: description,
//         date: date,
//         location: location,
//         organizer: organizer,
//         eventType: eventType,
//         updatedAt: new Date().toISOString()  // Automatically set updatedAt to the current time
//       });

//       return res.status(200).send({ status: "Success", msg: "Data Saved" });
//     } catch (error) {
//       console.log(error);
//       res.status(500).send({ status: "Failed", msg: error });
//     }
//   })();
// });

// // connecting server
// const server = express().use((req, res) => res.send('Hello World')).listen(PORT, () => console.log(`Listening on ${PORT}`));

// const wss = new Server({server});

// wss.on('connection', ws => {
//   console.log('Client connected');
//   ws.on('message', message => console.log(`Received: ${message}`));
//   ws.on('close', () => console.log('Client disconnected'));
// });
