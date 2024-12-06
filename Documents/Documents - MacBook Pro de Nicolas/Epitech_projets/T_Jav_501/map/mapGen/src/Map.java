
import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.paint.Color;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import Walls.*;

public class Map {
	
	protected Canvas canvas;
	protected GraphicsContext gc;
	protected List<Room> rooms = new ArrayList<Room>();
	protected double widthMap;
	protected double heightMap;
	protected int sideturn;
	
	public Map(Canvas canvas) {
		this.canvas = canvas;
		this.widthMap = canvas.getWidth();
		this.heightMap = canvas.getHeight();
		this.gc = this.canvas.getGraphicsContext2D();
		gc.setFill(Color.BLACK);
		this.gc.fillRect(0, 0, canvas.getWidth(), canvas.getHeight());
	}

	private List<Double> NextRoom(int countNone){
		Random random = new Random();
		//On defini la room qui va recevoir un voisin
		int nextRoom;
		double x;
		double y;
		if (countNone<3){//Si moins de 3 erreurs sur la création alors on génère une room à côté de la dernière créée. 
			nextRoom = this.rooms.size()-1;
			x = this.rooms.get(nextRoom).getX();
			y = this.rooms.get(nextRoom).getY();
		}else{ //sinon on prend une room aléatoire
			nextRoom = random.nextInt(this.rooms.size());
			x = this.rooms.get(nextRoom).getX();
			y = this.rooms.get(nextRoom).getY();
		}
		//Compte le nombre de voisin de cette room
		int count = 0;
		for(int i = 0;i<this.rooms.size();i++){
			if(i == nextRoom){
				continue;
			}
			if(this.rooms.get(i).getX()==x+50 && this.rooms.get(i).getY()==y){
				count++;
				continue;
			}if(this.rooms.get(i).getX()==x-50 && this.rooms.get(i).getY()==y){
				count++;
				continue;
			}if(this.rooms.get(i).getX()==x && this.rooms.get(i).getY()==y+25){
				count++;
				continue;
			}if(this.rooms.get(i).getX()==x && this.rooms.get(i).getY()==y-25){
				count++;
				continue;
			}
		}
		//Determine le nombre de voisin autorisées
		int AllowSide = 2;
		if(countNone>4){//Si plus de 4 erreurs 
			AllowSide = 3;
		}
		if(count >=AllowSide){//alors on retourne la position d'une room existante qui sera bloquée
			List<Double> pos = new ArrayList<>();
			pos.add(this.rooms.get(nextRoom).getX());
			pos.add(this.rooms.get(nextRoom).getY());
			return pos;
		}
		//On donne à x et y les valeurs
		int resultNext = random.nextInt(4); // un random sur les 4 cotés. 
		if(countNone<2){ //si ca beug moins de 3 fois on a une chance sur cinq d'avoir les 4 côtés. 
			int choice = random.nextInt(5);
			if (choice != 0){
				resultNext = this.sideturn;
			}
		}
		switch(resultNext){
			case(0)://top
				y -=25;
				this.sideturn=0;
				break;
			case(1)://bottom
				y +=25; 
				this.sideturn=1;
				break;
			case(2)://right
				x +=50;
				this.sideturn=2;
				break;
			case(3)://left
				x -=50;
				this.sideturn=3;
				break;
		}
		//on retourne une list des positions de la prochaine room
		List<Double> pos = new ArrayList<>();
		pos.add(x);
		pos.add(y);
		return pos;
	}


	public boolean startGeneration(double numberRooms) {
		//number of None new Room
		int countNone = 0; 

		//première position
		Random random = new Random();
		double y = random.nextInt((int)this.widthMap);
		double x = random.nextInt((int)this.heightMap);

		//créer la premiere room par default
		if(this.rooms.isEmpty()){
			// Draw image in GC
			Room room = new Room(x,y); 

			//add this rooms to list 
			this.rooms.add(room);
			//on créer la position de la prochaine rooms.
			List<Double> newPos = NextRoom(countNone);
			y = newPos.get(1);
			x = newPos.get(0);
		}
		//Pour les autres rooms
		while(this.rooms.size()<numberRooms){
			//si countNone plus de 100 on retourne false 
			if(countNone>100)return false;
			//on vérifie qu'une room n'a pas déjà été créé ici 
			boolean inRoom = false;
			int i = 0;
			while(i<this.rooms.size()){
				inRoom = this.rooms.get(i).inRoom(x,y);
				if (inRoom) break;
    			i++;
			}
			//on vérifie qu'on est pas hors des limites de map ou que inRoom == True
			if(x<0 || x+50>=this.widthMap || y<0 || y+25>this.heightMap || inRoom==true){
				List<Double> newPos = NextRoom(countNone);
				y = newPos.get(1); 
				x = newPos.get(0);
				countNone ++;
				continue; 
			}

			//On créer ou non une room 
			Random isRoom = new Random();
            int result = isRoom.nextInt(2);
			if(result==0){
				// Draw image in GC
				Room room = new Room(x,y); 
				//add this rooms to list 
				this.rooms.add(room);

			}
			List<Double> newPos = NextRoom(countNone);
			y = newPos.get(1);
			x = newPos.get(0);
			countNone = 0;
		}
		return true;
	}
	public void draw(){
		for(int i=0;i<this.rooms.size();i++){
			double x = this.rooms.get(i).getX();
			double y = this.rooms.get(i).getY();
			//image room 
			this.gc.drawImage(this.rooms.get(i).getImage(),x, y,50,25);
			//On vérifie que les room voisines 
			boolean Left = false;
			boolean Right = false;
			boolean Top = false;
			boolean Bottom = false;
			for(int z=0; z<this.rooms.size();z++){
				if(z==i){
					continue;
				}
				double xSide = this.rooms.get(z).getX();
				double ySide = this.rooms.get(z).getY();
				//check side 
				//Right
				if(xSide == x+50 && y == ySide){
					Right = true;
				}
				//left
				if(xSide == x-50 && y == ySide){
					Left = true;
				}
				//top 
				if(xSide == x && y-25 == ySide){
					Top = true;
				}
				//bottom 
				if(xSide == x && y+25 == ySide){
					Bottom = true;
				}
			}
			//affichage des murs 
			if(Left == false){
				LeftWall leftWall = new LeftWall(x-5,y);
				if(Top==false && Bottom==false){//si mur en haut et en bas
					leftWall.setY(-5);
					leftWall.setHeight(10);
				}else if(Top==false){
					leftWall.setY(-5);
					leftWall.setHeight(5);
				}else if(Bottom == false){
					leftWall.setHeight(5);
				}
				this.gc.drawImage(leftWall.getImage(),leftWall.getX(),leftWall.getY(),leftWall.getWidth(),leftWall.getHeight());
			}
			if(Right == false){
				RightWall rightWall = new RightWall(x+50,y);
				if(Top==false && Bottom==false){//si mur en haut et en bas
					rightWall.setY(-5);
					rightWall.setHeight(10);
				}else if(Top==false){
					rightWall.setY(-5);
					rightWall.setHeight(5);
				}else if(Bottom == false){
					rightWall.setHeight(5);
				}
				this.gc.drawImage(rightWall.getImage(),rightWall.getX(),rightWall.getY(),rightWall.getWidth(),rightWall.getHeight());
			}
			if(Top == false){
				TopWall topWall = new TopWall(x,y-5);
				this.gc.drawImage(topWall.getImage(),topWall.getX(),topWall.getY(),topWall.getWidth(),topWall.getHeight());
			}
			if(Bottom == false){
				BottomWall bottomWall = new BottomWall(x, y+25);
				this.gc.drawImage(bottomWall.getImage(),bottomWall.getX(),bottomWall.getY(),bottomWall.getWidth(),bottomWall.getHeight());
			}
		}
	}
	public Canvas getCanvas(){
		return this.canvas;
	}
	public GraphicsContext getGC(){
		return this.gc;
	}

	public List<Room> getRoom() {
    	return this.rooms;
    }

	public boolean checkCollision(double x, double y) {
		boolean response = false;
        // appele methode inRoom pour chaque room
		for(int i=0; i<this.rooms.size();i++){
			response = this.rooms.get(i).inRoom(x, y);
		}
		return response;	
    }
}
