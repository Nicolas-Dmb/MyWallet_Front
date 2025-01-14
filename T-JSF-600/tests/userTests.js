import request from 'supertest';
import mongoose from 'mongoose';
import { MongoMemoryServer } from 'mongodb-memory-server';
import app from './app';
import User from '../user/userModel.js';

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
    await User.deleteMany();
});

//'/signin'
    //Create user
    //Create with user with username already taken

//'/login'
    //login 
    //login without username register

//'/changename/:id'
    // Changename 
    // Changename without account register
    // Changename with username already taken 

//'/getlist'
    //getList of user 

describe('Create User')