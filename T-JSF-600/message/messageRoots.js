import express from 'express';
import { getMessages,sendMessage } from './messageController.js';

const router = express.Router();

router.get('/get/:id_channel', getMessages);//faire via socket et que les 10 derniers messages et peut revenir plus haut
router.post('/send', sendMessage);

export default router;