const functions = require('@google-cloud/functions-framework');

// רישום פונקציה שמגיבה לאירוע Pub/Sub (CloudEvent)
functions.cloudEvent('helloPubSub', cloudEvent => {
  // הפענוח של הודעת ה-Pub/Sub שמגיעה בפורמט Base64
  const base64name = cloudEvent.data.message.data;

  const name = base64name
    ? Buffer.from(base64name, 'base64').toString()
    : 'World';

  console.log(`Hello, ${name}!`);
});