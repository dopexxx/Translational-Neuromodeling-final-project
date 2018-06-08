int readout;
int val;

void setup() {
  Serial.begin(9600);

}

void loop() {
  while (Serial.available() == 0) 
  {
  }
  
  if (Serial.available() > 0)
  {
    val = Serial.read();
    if (val == 'G')
    {
      readout = analogRead(A0);
      Serial.println(readout);
      Serial.flush();
    }
  }
  delay(10);
  
}




