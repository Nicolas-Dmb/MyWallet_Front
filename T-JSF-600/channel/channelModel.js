import mongoose from 'mongoose';

const channelSchema = new mongoose.Schema({
    isChannel:{
        type:Boolean,
        required:true,
        default:true,
    },
    name:{
        type:String,
        required:true,
    },
    member:[
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User',
        },
    ],
},{collection:'channel'});

const Channel = mongoose.model('Channel', channelSchema);

export default Channel;
