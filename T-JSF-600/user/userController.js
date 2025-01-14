import User from './userModel.js';

// Obtenir tous les utilisateurs
export const getUsers = async (req, res) => {
  try {
    const users = await User.find();
    res.status(200).json(users); 
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
// Créer un nouvel utilisateur
export const createUser = async (req, res) => {
  const newUser = new User(req.body);
  try {
    await newUser.save();
    res.status(201).json({ message: 'User created successfully', user: newUser });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};
// loginUser
export const loginUser = async (req, res) => {
    const UserBody = req.body;
    const UserLogin = await User.findOne({username : UserBody['username']});
    try{
        if (UserLogin) {
        res.status(200).json({message: "Login successfully", user:UserLogin});
        } else {
            const newUser = new User(req.body);
            try {
                await newUser.save();
                res.status(201).json({ message: 'User created successfully', user: newUser });
            } catch (err) {
                res.status(400).json({ message: err.message });
            }
        }
    }catch (err){
        res.status(400).json({ message: err.message });
    }
};
//change name of user
export const changeName = async (req, res)=>{
    try {
        const { id } = req.params;
        const { username } = req.body;

        const updatedUser = await User.findByIdAndUpdate(
        id,
        { username }, 
        { new: true, runValidators: true } //l'option new:true permet de retourner la valeur mis à jour et non l'ancienne version
        );
    
        if (!updatedUser) {
        return res.status(404).json({ message: 'User not found' });
        }
    
        res.status(200).json({ message: 'User updated successfully', user: updatedUser });
    } catch (err) {
        res.status(500).json({ message: 'An error occurred', error: err.message });
    }
};
