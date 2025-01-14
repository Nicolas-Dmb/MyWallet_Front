import Message from './messageModel.js';
import User from '../user/userModel.js';
import Channel from '../channel/channelModel.js';

export const sendMessage = async (req, res) => {
    const { id_user, id_channel, message } = req.body;
    if (!id_user || !id_channel || !message) {
        return res.status(400).json({ message: "All fields (id_user, id_channel, message) are required" });
    }
    //verif channel_id
    const channel = await Channel.findById(id_channel);
    if (!channel){
        res.status(404).json({message:"None channel with this id"});
    }
    //verif user_id
    const user = await User.findById(id_user);
    if(!user){
        res.status(404).json({message:"None user with this id"});
    }
    const data = new Message(req.body);
    try{
        await data.save();
        res.status(201).json({message:"Message sent successfully" ,data:data});
    }catch (err){
        res.status(400).json({message:err.message});
    }
};

//modifier le getMessage pour récupérer les 20 derniers message et retourné une systeme de pagination. 
export const getMessages = async (req, res) => {
    const { id_channel } = req.params; 

    if (!id_channel) {
        return res.status(400).json({ message: "Channel ID is required" });
    }
    try{
        const returnData = await Message.find({id_channel});
        var messages = [];
        for (var i in returnData){
            console.log(`id User : ${returnData[i].id_user}`);
            const user = await User.findById(returnData[i].id_user);
            messages.push({'username':user['username'],'message':returnData[i].message});
        }
        res.status(200).json({message:returnData.length > 0 ? "Messages retrieved successfully" : "No messages found", data:messages});
    }catch (err){
        res.status(400).json({message:err.message});
    }
};

export const userJoin = async (id_channel, id_user) => {
    try{
        const user = await User.findById(id_user);
        const joinMessage = new Message({
            id_user,
            id_channel,
            message:`${user.username || "Unknown user"}  join channel.`,
        });
        await joinMessage.save();
        return {status: 201, message: "User join message logged successfully"};
    }catch (err){
        return {status: 400, message: err.message};
    }
};

export const userLeave = async (id_channel, id_user) => {
    try{
        const user = await User.findById(id_user);
        const joinMessage = new Message({
            id_user:id_user,
            id_channel:id_channel,
            message:`${user} leave channel.`,
        });
        await joinMessage.save();
        return {status: 201, message: "User leave message logged successfully"};;
    }catch (err){
        return {status: 400, message: err.message};
    }
};

export const sendFirstPrivateMessage = async (idChannel, text, idSender,) => {
    try{
        const channel = Channel.findById(idChannel);
        if(!channel){
            return {status:404, message: "can't find Channel."};
        }
        const message = new Message({
            id_user:idSender,
            id_channel:idChannel,
            message:text,
        })
        await message.save();
        return {status:201, message:'Succesfully created'};
    }catch(err){
        return {status:400, message: err.message};
    }
};