const express = require('express')
const { FieldValue } = require('firebase-admin/firestore');
const errors = require("./middleware/errors.js");

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const cors = require("cors");

const app = express();
const port = 8383;
const { db } = require('../firebase.js')
// app.use(cors());
app.use(cors({ origin: true }));
app.use(express.json());

app.use(errors.errorHandler);

const events = {
    'james': 'friend',
    'larry': 'friend',
    'lucy': 'friend',
    'banana': 'enemy',
}

app.get('/events', async (req, res) => {
    try {
        const eventsRef = db.collection('event'); // Reference to the 'event' collection
        const snapshot = await eventsRef.get(); // Get all documents in the collection
        
        if (snapshot.empty) {
            return res.sendStatus(404); // Return 404 if no documents found
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

app.get('/events/:name', (req, res) => {
    const { name } = req.params
    if (!name || !(name in events)) {
        return res.sendStatus(404)
    }
    res.status(200).send({ [name]: events[name] })
})

app.post('/events/addEvent', async (req, res) => {
    try {
        console.log(req.body);
        // Destructure all fields from the request body
        const { title, description, date, location, organizer, eventType, updatedAt } = req.body;

        // Log the incoming request for debugging purposes
        
        console.log(title, description, date, location, organizer, eventType);

        // Reference to the Firestore collection and document (assuming 'events' is your collection)

        // Generate a unique key using the current timestamp
        const timestamp = new Date().getTime().toString(); // Convert to string if needed

        const eventRef = db.collection('event').doc(timestamp);

        // Set the data in Firestore (using merge: true in case you want to preserve other fields)
        const res2 = await eventRef.set({
            // id: timestamp,
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

app.patch('/changestatus', async (req, res) => {
    const { name, newStatus } = req.body
    const eventRef = db.collection('event').doc('detail')
    const res2 = await eventRef.set({
        [name]: newStatus
    }, { merge: true })
    // events[name] = newStatus
    res.status(200).send(events)
})

app.delete('/events', async (req, res) => {
    const { id } = req.body.id
    const eventRef = db.collection('event').doc(id)
    const res2 = await eventRef.update({
        [name]: FieldValue.delete()
    })
    res.status(200).send(events)
})

app.listen(port, () => console.log(`Server has started on port: ${port}`));


// // Exports api to the firebase cloud functions
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
//       await db.collection("eventdetails").doc(`/${Date.now()}/`).create({
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

// // read specific user detail
// // get
// app.get("/api/eventDetail/:id", (req, res) => {
//   (async () => {
//     try {
//       const reqDoc = db.collection("eventdetails").doc(req.params.id);
//       let eventDetail = await reqDoc.get();
//       let response = eventDetail.data();

//       return res.status(200).send({ status: "Success", data: response });
//     } catch (error) {
//       console.log(error);
//       res.status(500).send({ status: "Failed", msg: error });
//     }
//   })();
// });

// // read all user details
// // get
// app.get("/api/events", (req, res) => {
//   (async () => {
//     try {
//       let query = db.collection("eventdetails");
//       let response = [];

//       await query.get().then((data) => {
//         let docs = data.docs; // query results

//         docs.map((doc) => {
//           const input = doc.data();
//           const selectedData = {
//             title: input.title,
//             description: input.description,
//             date: input.date,
//             location: input.location,
//             organizer: input.organizer,
//             eventType: input.eventType,
//             updatedAt: input.updatedAt
//           };

//           response.push(selectedData);
//         });
//         return response;
//       });

//       return res.status(200).send({ status: "Success", data: response });
//     } catch (error) {
//       console.log(error);
//       res.status(500).send({ status: "Failed", msg: error });
//     }
//   })();
// });

// // update
// // put
// app.put("/api/update/:id", (req, res) => {
//   (async () => {
//     try {
//       const reqDoc = db.collection("eventdetails").doc(req.params.id);

//       const { title, description, date, location, organizer, eventType } = req.body;
//       // Validate the request body fields
//       if (!title || !description || !date || !location || !organizer || !eventType) {
//           return res.status(400).json({ error: 'Missing required fields' });
//       }

//       await reqDoc.update({
//         title: title,
//         description: description,
//         date: date,
//         location: location,
//         organizer: organizer,
//         eventType: eventType,
//         updatedAt: new Date().toISOString()  // Automatically set updatedAt to the current time
//       });
//       return res.status(200).send({ status: "Success", msg: "Data Updated" });
//     } catch (error) {
//       console.log(error);
//       res.status(500).send({ status: "Failed", msg: error });
//     }
//   })();
// });

// // delete
// // delete
// app.delete("/api/delete/:id", (req, res) => {
//   (async () => {
//     try {
//       const reqDoc = db.collection("eventdetails").doc(req.params.id);
//       await reqDoc.delete();
//       return res.status(200).send({ status: "Success", msg: "Data Removed" });
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
