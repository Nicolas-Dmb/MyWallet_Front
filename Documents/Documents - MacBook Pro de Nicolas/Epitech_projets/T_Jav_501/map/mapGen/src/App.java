import javafx.stage.Stage;
import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.canvas.Canvas;
import javafx.scene.layout.Pane;

import java.awt.Toolkit;
import java.awt.Dimension;

public class App extends Application{
    public void start(Stage primaryStage){
        //Gère la taille de l'écran
        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        double width = screenSize.getWidth();
        double height = screenSize.getHeight();
    
        Canvas canvas = new Canvas(width,height);
        Pane pane = new Pane();
        //generation de la map
        Map map = new Map(canvas);
        boolean result =  map.startGeneration((width*height/(25*50))/3);
        while(result==false){
            result = map.startGeneration((width*height/(25*50))/3);
        }
        map.draw();
        //Spawn door
        Doors door = new Doors(map);
        door.draw(map.getGC());
        pane.getChildren().add(map.getCanvas());
        //on initialise la scene :
        Scene scene = new Scene(pane, width,height);
        //initialisation de PrimaryStage
        primaryStage.setTitle("Minotaure mistery");
        //primaryStage.setMaximized(true); //la page d'affichage
        primaryStage.setScene(scene); //ajoute tous les éléments de la scene à la page 
        primaryStage.show();
    }
    public static void main(String[] args) throws Exception {
        launch(args);
    }
}
