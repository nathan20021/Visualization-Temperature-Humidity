import processing.serial.*;

//Make Sure to change the COM port before use
String portName = Serial.list()[2];
Serial ardPort; //Create object from Serial class
String valString = null;
float temp;
float humid;
int indexOfSpace;
int nl = 10; //Ascii code for a new line
int time;
float[] tempArray = new float[72];
float[] humidArray = new float[72];
int counter = 0;
float scaleTime = 800/72;
float scaleHumid = 350/100;
float scaleTemp = 350/60;
boolean drawTemp = true;
boolean drawHumid = true;
int s, m, h, startTime, preM;


void drawAxises(boolean drawTemp, boolean drawHumid){
 noFill();
 stroke(255);
 //Time x-axis
 line(100, 500, 900, 500);
 strokeWeight(0.5);
 for(int i = 1; i <= 72; i++){
   textAlign(CENTER);
   if(i%6 == 0){
     textSize(10);
     line(100+(scaleTime*i), 500+10, 100+(scaleTime*i), 500-10);
     text(i/6, 100+(scaleTime*i), 500+20);
   }else{
   textSize(5);
   line(100+(scaleTime*i), 500+5, 100+(scaleTime*i), 500-5);
   text(i*10 ,100+(scaleTime*i), 500+10);
   }
 }
 
 if(drawHumid && drawTemp == false){
   strokeWeight(2);
   line(100, 150, 100, 500);
   strokeWeight(0.5);
   for(int i = 1; i <= 100; i++){
     textAlign(CENTER);
     if(i%10 == 0){
       textSize(10);
       line(90, 500-(scaleHumid*(i)), 110, 500-(scaleHumid*(i)));
       text(i ,80, 500-(scaleHumid*(i)));
     }
   }
 }
 else{
   if(drawHumid){
      strokeWeight(2);
     //This one is for Humidity
     line(900, 150, 900, 500);
     strokeWeight(0.5);
     for(int i = 1; i <= 100; i++){
       textAlign(CENTER);
       if(i%10 == 0){
         textSize(10);
         line(890, 500-(scaleHumid*(i)), 910, 500-(scaleHumid*(i)));
         text(i ,920, 500-(scaleHumid*(i)));
      }
     }
    }
   if(drawTemp){
      strokeWeight(2);
     //This one is for Temperature
     line(100,150,100, 500);
     //Draw the horizontal lines on the temp-axis   
     strokeWeight(0.5);
     for(int i = 1; i <= 60; i++){
       textAlign(CENTER);
       if(i%10 == 0){
         textSize(10);
         line(90, 500-(scaleTemp*(i)), 110, 500-(scaleTemp*(i)));
         text(i ,80, 500-(scaleTemp*(i)));
      }
    } 
  }
}
 
 textSize(20);
 text("Time(hour)", 500, 570);
 //legend
 textAlign(LEFT);
 textSize(15);
 strokeWeight(1);
 rect(750, 15, 200, 100);
 strokeWeight(5);
 stroke(77, 139, 219);
 line(790, 45, 820, 45);
 text("Humidity", 830, 50);
 //Set color to orange
 stroke(230, 138, 80);
 //draw the lines
 line(790, 85, 820, 85);
 text("Tempurature", 830, 90);
}

void setup(){
 //fullScreen(); 
 size(1000,600);
 background(0);
 ardPort = new Serial(this, portName, 9600);//"this" refers to the sketch
 startTime = minute();
}


void draw(){ 
  background(0);
  h = hour();
  m = minute();
  s = second();
  time = millis();
  text(h, 350, 50);
  text(m, 380, 50);
  text(s, 410, 50);
  drawAxises(drawTemp, drawHumid);
  fill(0);
  noStroke();
  //rect(0,0,100,100);
 // Check if the serial port is available
 while(ardPort.available() > 0){
   // Get the data that Arduino sent to the Serial port
   valString = ardPort.readStringUntil(nl); 
   // Check if the data is stored in valString
   if(valString != null){
       // Find the index of the space from the recieved data
       indexOfSpace = valString.indexOf(" ");
       // Check if the data is formated probably
       // the correct format should be ("{temp} {humid}")
       while(indexOfSpace!= -1){
         //Save the value of temperature and humidty
         temp = float(valString.substring(0, indexOfSpace));
         humid = float(valString.substring(indexOfSpace));
         if(0 < temp && temp < 60) {
           if(0 < humid && humid < 100){
             break;
           }
         }
       }
     }
   }
   //If 10 minutes has passed
  if((time % 1000) <= 20){
    //Shift everything to the right
    float preHumid = humidArray[0];
    float preTemp = tempArray[0];
    
    for(int i = 1; i < 72; i++){
      float memTemp = tempArray[i];
      tempArray[i] = preTemp;
      preTemp = memTemp;
      float memHumid = humidArray[i];
      humidArray[i] = preHumid;
      preHumid = memHumid;
     }
    //Add an element
    tempArray[0] = temp;
    humidArray[0] = humid;
  }
  for(int i = 0; i < tempArray.length; i++){
    float tempPoint = tempArray[i];
    float humidPoint = humidArray[i];
    if(tempPoint == 0 || humidPoint == 0){
    continue;
    }else{   
      //Connecting the lines
      if(i != 0){
       strokeWeight(1);
       if(drawHumid){
         stroke(77, 139, 219);
         line(100+((i+1)*scaleTime), 500-(humidPoint*scaleHumid), 100+((i)*scaleTime), 500-(humidArray[i-1]*scaleHumid));
       }
       if(drawTemp){
         stroke(230, 138, 80);
         line(100+((i+1)*scaleTime), 500-(tempPoint*scaleTemp), 100+((i)*scaleTime), 500-(tempArray[i-1]*scaleTemp));
       }
      }
      //Drawing all the points
      strokeWeight(4);
      if(drawTemp){
        stroke(230, 138, 80);
        point(100+((i+1)*scaleTime), 500-(tempPoint*scaleTemp));
      }
      //Draw the temperature
      if(drawHumid){
        stroke(77, 139, 219);
        point(100+((i+1)*scaleTime), 500-(humidPoint*scaleHumid)); 
      }
    }
  }
  //Display the checkBoxes
  stroke(255);
  strokeWeight(1);
  noFill();
  rect(770, 40, 10, 10);
  rect(770, 80, 10, 10);
  if(drawHumid){
    strokeWeight(1);
    line(770, 40, 780, 50);
    line(780, 40, 770, 50);
  }
  if(drawTemp){
    strokeWeight(1);
    line(770, 80, 780, 90);
    line(780, 80, 770, 90);
  }
  //Dispay all the informations
   textSize(15);
   fill(255);
   //println(valString);
   //println("temp is: " +temp);
   text(temp, 10, 50);
   //println("humid is: " +humid);
   text(humid, 10, 70);
   text(time, 10, 90);
}

void mousePressed(){
 if(770 <=mouseX && mouseX <=780){
  if(40 <=mouseY && mouseY <=50){
    if(drawHumid == true){
     drawHumid = false; 
    }else{
      drawHumid = true; 
    }
   }
  }
 if(770 <=mouseX && mouseX <=780){
  if(80 <=mouseY && mouseY <=90){
    if(drawTemp == true){
     drawTemp = false; 
    }else{
      drawTemp = true; 
    }
   }
  }  
}
