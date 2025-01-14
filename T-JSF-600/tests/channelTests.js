import request from 'supertest';
import mongoose from 'mongoose';
import { MongoMemoryServer } from 'mongodb-memory-server';
import app from './app';
import Message from '../message/messageModel.js';

let mongoServer;

beforeAll(async ()=>{
    mongoServer = await MongoMemoryServer.create();
    const uri = mongoServer.getUri();
    await mongoose.connect(uri);
});

afterAll( async ()=>{
    await mongoose.disconnect();
    await mongoServer.stop();
});
afterEach( async ()=>{
    await Message.deleteMany();
});


// '/newprivate'
    // Créer un channel privé et vérifier que le message est bien envoyé et que les deux users sont dedans 
    // Créer un channel privé avec un idSender mauvais 
    // Créer un channel privé avec un text inexistant
    // Créer un channel privé avec un idConsignee mauvais 

// '/new'
    // Créer un chanel classique 
    // Créer un chanel classque 

router.post('/newprivate', NewPrivateMessage);//{'idSender','text','idConsignee'}
router.post('/new', newChannel);//{isChannel,name,member} member est une list 
router.get('/:id', getChannel);//uniquement l'id dans l'ur
router.get('/list',getListChannel);//aucune donnée à envoyer``
router.delete('/delete/:id', deleteChannel);//id dans l'url
router.post('/join/:id', joinChannel);//id du channel dans l'url
router.post('/join', joinChannels);//join list of channelID in body
router.delete('/leave/:idchannel/:iduser', leaveChannel);//leave Channel avec idChannel puis idUser dans le params