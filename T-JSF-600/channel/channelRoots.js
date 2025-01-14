import express from 'express';
import {  NewPrivateMessage, newChannel, getChannel, getListChannel, deleteChannel, joinChannel, joinChannels, leaveChannel} from './channelController.js';

const router = express.Router();

router.post('/newprivate', NewPrivateMessage);//{'idSender','text','idConsignee'}
router.post('/new', newChannel);//{isChannel,name,member} member est une list 
router.get('/:id', getChannel);//uniquement l'id dans l'ur
router.get('/list',getListChannel);//aucune donnée à envoyer``
router.delete('/delete/:id', deleteChannel);//id dans l'url
router.post('/join/:id', joinChannel);//id du channel dans l'url
router.post('/join', joinChannels);//join list of channelID in body
router.delete('/leave/:idchannel/:iduser', leaveChannel);//leave Channel avec idChannel puis idUser dans le params

export default router;