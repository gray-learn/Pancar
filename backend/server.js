const express = require('express')
const { FieldValue } = require('firebase-admin/firestore')
const app = express()
const port = 8383
const { db } = require('./firebase.js')

app.use(express.json())

const events = {
    'james': 'friend',
    'larry': 'friend',
    'lucy': 'friend',
    'banana': 'enemy',
}

app.get('/events', async (req, res) => {
    const peopleRef = db.collection('event').doc('detail')
    const doc = await peopleRef.get()
    if (!doc.exists) {
        return res.sendStatus(400)
    }

    res.status(200).send(doc.data())
})

app.get('/events/:name', (req, res) => {
    const { name } = req.params
    if (!name || !(name in events)) {
        return res.sendStatus(404)
    }
    res.status(200).send({ [name]: events[name] })
})

app.post('/addEvent', async (req, res) => {
    try {
        // Destructure all fields from the request body
        const { title, description, date, location, organizer, eventType, updatedAt } = req.body;

        // Log the incoming request for debugging purposes
        console.log(req.body);
        console.log(title, description, date, location, organizer, eventType);

        // Reference to the Firestore collection and document (assuming 'events' is your collection)
        const eventRef = db.collection('event').doc('detail');

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

app.patch('/changestatus', async (req, res) => {
    const { name, newStatus } = req.body
    const peopleRef = db.collection('event').doc('detail')
    const res2 = await peopleRef.set({
        [name]: newStatus
    }, { merge: true })
    // events[name] = newStatus
    res.status(200).send(events)
})

app.delete('/events', async (req, res) => {
    const { name } = req.body
    const peopleRef = db.collection('event').doc('detail')
    const res2 = await peopleRef.update({
        [name]: FieldValue.delete()
    })
    res.status(200).send(events)
})

app.listen(port, () => console.log(`Server has started on port: ${port}`))