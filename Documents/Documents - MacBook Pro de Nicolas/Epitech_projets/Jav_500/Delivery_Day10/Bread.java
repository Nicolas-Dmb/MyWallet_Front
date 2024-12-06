abstract class Bread implements Food{
    protected float price;
    protected int calories;
    protected int bakingTime = 0;

    protected Bread(float price_input, int calories_input){
        this.price = price_input;
        this.calories = calories_input;
    }
    public float getPrice(){
        return this.price;
    }
    public int getCalories(){
        return this.calories;
    }
    public int getBakingTime(){
        return this.bakingTime;
    }
}
