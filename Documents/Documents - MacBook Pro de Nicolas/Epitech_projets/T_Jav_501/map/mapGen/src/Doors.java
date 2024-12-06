
import java.util.Random;
import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.image.Image;
import javafx.scene.paint.Color;

import java.util.ArrayList;
import java.util.List;

public class Doors {
	
	private double x,y; // Position de la porte
    private Image image;
	
	// Référence à la carte du jeu
    private Map mapGenerator;
    
    public Doors(Map mapGenerator) {
        this.mapGenerator = mapGenerator;
        this.image = new Image(getClass().getResource("/tiles/door.png").toExternalForm());
        spawn();
    }
    
    // Trouver un point valide pour le spawn dans une zone verte
    private void spawn() {
        Random random = new Random();
        int room = random.nextInt(this.mapGenerator.getRoom().size());
        this.x = (this.mapGenerator.getRoom().get(room).getX()+25);
        this.y = (this.mapGenerator.getRoom().get(room).getY()+12.5);
    }

    public List<Double> doorposition(){
        // Récupérer, stocker et envoyer la position de la porte
        List<Double> doorPos = new ArrayList<>();
        doorPos.add(this.x);
        doorPos.add(this.y);
        return doorPos;
    }

    public void draw(GraphicsContext gc) {
        gc.drawImage(this.image,this.x, this.y, 10, 10); 
    }

}
