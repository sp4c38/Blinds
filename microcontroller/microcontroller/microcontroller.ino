/*
  Script to control the microcontroller for the window blinds project.
*/

const int PUSH_BUTTON_PIN = 12; // Corresponds to GPIO D6
const int MOTOR_ON_OFF_RELAIS_PIN = 5; // Corresponds to GPIO D1
const int MOTOR_DIRECTION_RELAIS_1_PIN = 4; // Corresponds to GPIO D2
const int MOTOR_DIRECTION_RELAIS_2_PIN = 0; // Corresponds to GPIO D3

void setup() {
  Serial.begin(9600);

  // Push button
  pinMode(PUSH_BUTTON_PIN, INPUT);
  
  // LED
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH);
  
  // Motor on/off relais
  pinMode(MOTOR_ON_OFF_RELAIS_PIN, OUTPUT);
  digitalWrite(MOTOR_ON_OFF_RELAIS_PIN, LOW);
  
  
  // Motor direction relais
  pinMode(MOTOR_DIRECTION_RELAIS_1_PIN, OUTPUT);
  digitalWrite(MOTOR_DIRECTION_RELAIS_1_PIN, LOW);
  
  pinMode(MOTOR_DIRECTION_RELAIS_2_PIN, OUTPUT);
  digitalWrite(MOTOR_DIRECTION_RELAIS_2_PIN, LOW);
}

int pushButtonCycleCount = 0;

void toggleBlinds() {
    digitalWrite(LED_BUILTIN, LOW);
    digitalWrite(MOTOR_DIRECTION_RELAIS_1_PIN, HIGH);
    digitalWrite(MOTOR_DIRECTION_RELAIS_2_PIN, HIGH);
    delay(200);
    digitalWrite(MOTOR_ON_OFF_RELAIS_PIN, HIGH);
    
    delay(5000);

    digitalWrite(MOTOR_ON_OFF_RELAIS_PIN, LOW);
    delay(200);
    digitalWrite(MOTOR_DIRECTION_RELAIS_1_PIN, LOW);
    digitalWrite(MOTOR_DIRECTION_RELAIS_2_PIN, LOW);
    delay(1000);
    digitalWrite(MOTOR_ON_OFF_RELAIS_PIN, HIGH);
    
    delay(5000);
    
    digitalWrite(LED_BUILTIN, HIGH);
    digitalWrite(MOTOR_ON_OFF_RELAIS_PIN, LOW);
    delay(200);
    digitalWrite(MOTOR_DIRECTION_RELAIS_1_PIN, LOW);
    digitalWrite(MOTOR_DIRECTION_RELAIS_2_PIN, LOW);
}

void loop() {
   int pushButtonState = digitalRead(PUSH_BUTTON_PIN);
   
   if (pushButtonState == HIGH) {
     pushButtonCycleCount += 1;
   } else {
     pushButtonCycleCount = 0;
   }
   
   if (pushButtonCycleCount == 3) {
     toggleBlinds();
   }
   
   delay(200); // in milliseconds
}
