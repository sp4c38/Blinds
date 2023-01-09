#include <ESP8266WiFi.h>
#include <ArduinoHA.h>

WiFiClient client;
HADevice device;
HAMqtt mqtt(client, device);

// Define devices
HASwitch relaisA("relaisA");
HASwitch relaisB("relaisB");
HASwitch motorSwitch("motorSwitch");
HASwitch sensorSwitch("sensorSwitch");
HACover cover("blinds");

// Define pin numbers
const int motor_on_off_gpio = 5;
const int motor_direction_1_gpio = 4;
const int motor_direction_2_gpio = 0;
// const int push_button_gpio = 12;
const int infrared_input_gpio = 13; // LOW: Object present, HIGH: object not present
const int infrared_on_off_gpio = 14;

void onMotorSwitchCommand(bool state, HASwitch* sender) {
  Serial.println("Motor switch clicked in homeassistant.");
  digitalWrite(motor_on_off_gpio, state ? HIGH : LOW);
  sender->setState(state);
}

void onRelaisACommand(bool state, HASwitch* sender) {
  Serial.println("Relais A switch clicked in homeassistant.");
  digitalWrite(motor_direction_1_gpio, state ? HIGH : LOW);
  sender->setState(state);
}

void onRelaisBCommand(bool state, HASwitch* sender) {
  Serial.println("Relais B switch clicked in homeassistant.");
  digitalWrite(motor_direction_2_gpio, state ? HIGH : LOW);
  sender->setState(state);
}

void onSensorSwitchCommand(bool state, HASwitch* sender) {
  Serial.println("Infrared switch clicked in homeassistant.");
  digitalWrite(infrared_on_off_gpio, state ? HIGH : LOW);
  sender->setState(state);
}

void onCoverCommand(HACover::CoverCommand cmd, HACover* sender) {
  digitalWrite(infrared_on_off_gpio, HIGH);
  delay(200);
  if (cmd == HACover::CommandClose) {
    Serial.println("Closing blinds.");
    sender->setState(HACover::StateClosing);
    
    digitalWrite(motor_direction_1_gpio, HIGH);
    int infrared_state = digitalRead(infrared_input_gpio);
    while (infrared_state == HIGH) {
      delay(100);
      infrared_state = digitalRead(infrared_input_gpio);
    }
    delay(28 * 1000);
    digitalWrite(motor_direction_1_gpio, LOW);
    sender->setState(HACover::StateClosed);
  } else if (cmd == HACover::CommandOpen) {
    Serial.println("Opening blinds.");
    sender->setState(HACover::StateOpening);
    
    digitalWrite(motor_direction_2_gpio, LOW);
    int infrared_state = digitalRead(infrared_input_gpio);
    while (infrared_state == LOW) {
      delay(100);
      infrared_state = digitalRead(infrared_input_gpio);
    }
    delay(1 * 10);
    digitalWrite(motor_direction_2_gpio, HIGH);
    sender->setState(HACover::StateOpen);
  }
  digitalWrite(infrared_on_off_gpio, LOW);
}

void setup() {
  // -- GENERAL SETUP
  Serial.begin(115200);
  
  // -- SETUP PINS
  pinMode(motor_on_off_gpio, OUTPUT);
  pinMode(motor_direction_1_gpio, OUTPUT);
  pinMode(motor_direction_2_gpio, OUTPUT);
  pinMode(infrared_input_gpio, INPUT);
  pinMode(infrared_on_off_gpio, OUTPUT);
  
  digitalWrite(motor_direction_1_gpio, LOW);
  digitalWrite(motor_on_off_gpio, HIGH);
  digitalWrite(motor_direction_2_gpio, HIGH);
  digitalWrite(infrared_on_off_gpio, LOW);
  
  // -- SETUP ArduinoHA
  byte mac[WL_MAC_ADDR_LENGTH];
  WiFi.macAddress(mac);
  
  // HADevice needs a unique id to identify itself towards homeassistant. The id may only be used once across the homeassistant instance.
  device.setUniqueId(mac, sizeof(mac));
  device.setName("Léon Bedroom Blinds Controller");
  device.setManufacturer("Rolling Rollers Corp.");
  device.enableSharedAvailability();
  device.enableLastWill();
  
  WiFi.begin("kruitzer", "Hu88l3Bu88l3");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500); // waiting for the connection
  }
  
  // Setup devices
  motorSwitch.setName("Motor On/Off Switch");
  motorSwitch.onCommand(onMotorSwitchCommand);
  motorSwitch.setCurrentState(true);
  
  relaisA.setName("Motor Direction 1 Switch");
  relaisA.onCommand(onRelaisACommand);
  relaisA.setCurrentState(false);

  relaisB.setName("Motor Direction 2 Switch");
  relaisB.onCommand(onRelaisBCommand);
  relaisB.setCurrentState(true);

  sensorSwitch.setName("Sensor Switch");
  sensorSwitch.onCommand(onSensorSwitchCommand);
  sensorSwitch.setCurrentState(false);
  
  cover.setName("Blinds");
  cover.onCommand(onCoverCommand);
  cover.setCurrentState(CoverState.StateOpened);
  
  mqtt.begin("pi3.local", 1883, "leon_blinds", "uv*dce3u,gaXP8msK2/#}Pt6D]+tFghq2Zx=3bUN42qBje)7^4J");
}

void loop() {
  // put your main code here, to run repeatedly:
  mqtt.loop();
  delay(1000);
}
