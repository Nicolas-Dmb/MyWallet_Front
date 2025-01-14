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

//'/get/:id_channel'
    // vérifier de recevoir les messages channel public 
    // vérifier de recevoir lesm messages channel privé 
    // Essayer avec un idchannel inexistant 
 
//'/send'
    // Envoyer un message dans un channel public 
    // Envoyer un message dans un channel privé 
    // Envoyer un message avec un mauvais idChannel 
    // Envoyer un message avec un mauvais idUser 
    // Envoyer un message avec un mauvais test
    
