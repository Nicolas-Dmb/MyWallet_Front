package Walls;
import javafx.scene.image.Image;

public class Wall {
    Image image;
    int width;
    int height;
    double x;
    double y;

    // Ajuster la taille
    protected Wall(String link,int width,int height, double x, double y){
        this.image = new Image(getClass().getResource(link).toExternalForm());
        this.width = width;
        this.height = height;
        this.x = x;
        this.y=y;
    }
    public Image getImage(){
        return this.image;
    }
    public double getX(){
        return this.x;
    }
    public double getY(){
        return this.y;
    }
    public int getWidth(){
        return this.width;
    }
    public int getHeight(){
        return this.height;
    }
    public void setHeight(int height){
        this.height += height;
    }
    public void setY(double y){
        this.y+=y;
    }
}
