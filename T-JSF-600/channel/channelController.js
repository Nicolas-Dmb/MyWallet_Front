import Channel from './channelModel.js';
import User from '../user/userModel.js';

export const NewPrivateMessage = async (req, res) =>{
    //génère un channelPrivé
    try{
        const sender = await User.findById(req.body['idSender']);
        const consignee = await User.findById(req.body['idConsignee']);
        if (!consignee){
            res.status(404).json({message:"Consignee undiscovered"});
        }
        const newPrivateChannel = new Channel({
            'isChannel':false,
            'name':consignee.username,
            'member':[{sender,consignee}],
            });
        await newPrivateChannel.save();
    }catch (err){
        res.status(400).json({message:err.message});
    }
    //Envoie le message 
    const response = await sendFirstPrivateMessage(req.body['idSender'], req.body['text'], req.body['idConsignee']);
    res.status(response.status).json({message:response.message, data:newPrivateChannel});
}

export const newChannel = async (req, res) => {
    try{
        //Il faut modifier ici pour récupérer les users avant de les renseigner en tant que membre channel 
        const channel = new Channel({
            'isChannel':true,
            'name':req.body['name'],
            'member':req.body['member'],
        });
        await channel.save();
        res.status(201).json({message:"Succesfuly created", data:channel});
    }catch (err){
        res.status(400).json({message:err.message});
    }
}

export const getChannel = async (req, res) => {
    try{
        const channel = await Channel.findById(req.params);
        if (!channel){
            res.status(404).json({message:"Can't find this Channel"});
        }
        res.status(200).json({message:"Succesfully find the Channel", data:channel});
    }catch(err){
        res.status(400).json({message:err.message});
    }
}

export const getListChannel = async (req, res) => {
    try{
        const channels = await Channel.find({'isChannel':false});
        res.status(200).json({message:channels.length > 0 ?"Succesfully some Channels":"None channel", data:channels});
    }catch (err){
        res.status(400).json({message:err.message});
    }
}

export const deleteChannel = async(req, res) => {
    try{
        const channel = await Channel.findById(req.params);
        if (!channel){
            res.status(404).json({message:"Can't find this Channel"});
        }
        await Channel.deleteOne({_id:req.params});
    }catch (err){
        res.status(400).json({message:err.message});
    }
}

//retourné l'id du channel dans l'url et userId dans body 
export const joinChannel = async (req, res) => {
    try{
        const { id } = req.params;
        const { userId } = req.body;
        const user = await User.findById(userId);
        if(!user){
            res.status(404).json({message:"Can't find this User"});
        }
        const channel = await Channel.findById(id);
        if(!channel){
            res.status(400).json({message:"Can't find this channel"});
        }
        if(!channel.isChannel){
            res.status(400).json({message:"Can't add user to private channel"});
        }
        const updateChannel = await Channel.findByIdAndUpdate(
            id,
            {$addToSet: { member: user._id }}, 
            { new: true, runValidators: true }
        );
        res.status(200).json({message:"Succesfully add user", data:updateChannel});
    }catch{
        res.status(400).json({message:err.message});
    }
}

//Rejoindre plusieurs channels
export const joinChannels = async (req, res) => {
    try{
        //récupérer l'user 
        const { userId } = req.body;
        const user = await User.findById(userId);
            if(!user){
                res.status(404).json({message:"Can't find this User"});
            }
        //gère l'ajout de membre a chaque channel
        const { channels } = req.body;
        const data = [];
        for(var i in channels){
            const channel = await Channel.findById(channels[i]);
            if(!channel){
                res.status(400).json({message:"Can't find this channel"});
            }
            if(!channel.isChannel){
                res.status(400).json({message:"Can't add user to private channel"});
            }
            const updateChannel = await Channel.findByIdAndUpdate(
                channels[i],
                {$addToSet: { member: user._id }}, 
                { new: true, runValidators: true }
            );
            data.push(updateChannel);
        }
        res.status(200).json({message:"Succesfully add user", data:data});
    }catch{
        res.status(400).json({message:err.message});
    }
}

export const leaveChannel = async (req,res) => {
    try{
        const { id } = req.params;
        const { iduser } = req.params;
        const user = await User.findById(iduser);
        //vérifier l'id user
        if(!user){
            res.status(404).json({message:"Can't find this User"});
        }
        const channel = await Channel.findById(id);
        //vérifier le channel
        if(!channel){
            res.status(400).json({message:"Can't find this channel"});
        }
        //vérifier que le channel n'est pas une messagerie privée
        if(!channel.isChannel){
            res.status(400).json({message:"Can't add user to private channel"});
        }
        const updateChannel = await Channel.findByIdAndUpdate(
            id,
            {$pull: { member: user._id }}, 
            { new: true, runValidators: true }
        );
        res.status(200).json({message:"Succesfully add user", data:updateChannel});
    }catch{

    }
}