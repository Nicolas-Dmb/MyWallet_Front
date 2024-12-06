import javafx.scene.image.Image;


public class Room {
    Image image = new Image(getClass().getResource("/tiles/room.png").toExternalForm());
    int width=50;
    int height=25;
    double x;
    double y;

    // Ajuster la taille
    public Room(double x, double y){
        this.x = x;
        this.y = y;
    }
    public  Image getImage(){
        return this.image;
    }
    
    public boolean inRoom(double posX, double posY){
        //if(this.x <= posX && this.x + this.width >= posX && this.y <= posY && this.y + this.height >= posY){
        if(this.x == posX && this.y == posY){
            return true; // Si le point est dans la salle
        }
        return false;
    }
    public double getX(){
        return this.x;
    }
    public double getY(){
        return this.y;
    }
}
