import express from 'express';
import connectToDatabase from './db/connection.js';  
import userRoots from './user/userRoots.js';
import channelRoots from './channel/channelRoots.js';
import messageRoots from './message/messageRoots.js';

const app = express();
app.use(express.json());

// Connexion à la base de données
connectToDatabase();

// Routes de votre application
app.get('/', (req, res) => {
  res.send('Welcome to API of EPIChan ! <br> - /user : to manage User, <br> - /channel : to manage Channel, <br> - /message to manage message,');
});

// Démarrage du serveur Express
app.listen(3000, () => {
  console.log(`Server is running on port 3000`);
});


app.use('/user', userRoots);
app.use('/channel', channelRoots);
app.use('/message', messageRoots);

export default app;