import express from 'express';
import { getUsers, createUser, loginUser, changeName} from './userController.js';

const router = express.Router();

router.get('/getlist', getUsers);
router.post('/signin', createUser); 
router.post('/login', loginUser);
router.post('/changename/:id', changeName);

export default router;