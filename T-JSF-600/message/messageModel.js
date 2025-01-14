import mongoose from 'mongoose';

const messageSchema = new mongoose.Schema({
    id_user:{
        type: String,
        required: true,
    },
    id_channel:{
        type: String,
        required: true,
    },
    message:{
        type: String,
        required: true,
    },
    date:{
        type: Date, 
        required: true, 
        default: Date.now,
    }
},{ collection: 'message'});

const Message = mongoose.model('Message', messageSchema);

export default Message;