#include <SimpleDHT.h>
#include <LiquidCrystal.h>

LiquidCrystal lcd(7, 8, 9, 10, 11, 12);
SimpleDHT11 sensor;

String temp;
String humid;
int sensorPin = 2;


void setup() {
  lcd.begin(16, 2);
  Serial.begin(9600);
}

void loop() {
  byte temperature = 0;
  byte humidity = 0;
  byte data[40] = {0};
  if(sensor.read(sensorPin, &temperature, &humidity, data)) {
    return;
  }
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("Temperature: ");
  lcd.setCursor(13,0);
  lcd.print((int)temperature);
  Serial.print((int)temperature);
  Serial.print(" ");
  lcd.setCursor(15,0);
  lcd.print("*C");
  lcd.setCursor(0,1);
  lcd.print("Humidity: ");
  lcd.setCursor(10,1);
  lcd.print((int)humidity);
  Serial.print((int)humidity);
  Serial.println("");
  lcd.setCursor(13,1);
  lcd.print("%");
  //Serial.println((int)temperature);
  delay(10);
}
