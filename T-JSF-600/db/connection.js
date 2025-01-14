import mongoose from 'mongoose';  // Import de Mongoose

const uri = "mongodb+srv://nickdev30:0fTD3iTyZfY2lX1V@cluster0.yyp3l.mongodb.net/Nicolas?retryWrites=true&w=majority";

// Fonction pour connecter à MongoDB
const connectToDatabase = async () => {
  try {
    // Connexion à MongoDB avec Mongoose
    await mongoose.connect(uri, { useNewUrlParser: true, useUnifiedTopology: true });
    console.log("Successfully connected to MongoDB!");
  } catch (error) {
    console.error("Error connecting to MongoDB:", error);
    process.exit(1); // Arrêter le processus si la connexion échoue
  }
};

export default connectToDatabase;