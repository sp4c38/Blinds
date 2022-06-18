// Logging levels:
//  - ERROR: ESP_LOGE
//  - WARNING: ESP_LOGW
//  - INFO: ESP_LOGI
//  - DEBUG: ESP_LOGD
//  - VERBOSE: ESP_LOGV
//  - VERY_VERBOSE: ESP_LOGVV

const int motor_switch_update_interval = 500; // ms

class BlindsMotorSwitch: public PollingComponent, public Switch {
	public:
		BlindsMotorSwitch(): PollingComponent(motor_switch_update_interval) {}
	
		const int motor_on_off_gpio = 5;
		const int motor_direction_1_gpio = 4;
		const int motor_direction_2_gpio = 0;
		
		const int move_down_time = 5; // sec
		const int move_up_time = 10; // sec
		
		const int push_button_gpio = 12;
		const int push_button_press_time = 3; // sec; specified time - update interval < actual time < specified time
		int push_button_cycle_count = 0;
	
		void setup() override {
			pinMode(motor_on_off_gpio, OUTPUT);
			pinMode(motor_direction_1_gpio, OUTPUT);
			pinMode(motor_direction_2_gpio, OUTPUT);
			pinMode(push_button_gpio, INPUT);
			
			digitalWrite(motor_on_off_gpio, LOW);
			digitalWrite(motor_direction_1_gpio, LOW);
			digitalWrite(motor_direction_2_gpio, LOW);
		
			ESP_LOGD("custom", "Finished motor switch setup.");
		}
		
		void update() override {
			const int pushButtonState = digitalRead(push_button_gpio);
			
			if (pushButtonState == HIGH) {
				push_button_cycle_count += 1;
			} else {
				push_button_cycle_count = 0;
			}
			
			if (push_button_cycle_count == (push_button_press_time*1000/motor_switch_update_interval)) {
				toggle();
			}
		}
		
		void write_state(bool state) override {
			publish_state(state);
		
			const bool on = true;
			const bool off = false;
			
			if (state == off) {
				digitalWrite(motor_direction_1_gpio, HIGH);
				digitalWrite(motor_direction_2_gpio, HIGH);
				
				delay(1000);
			}
			
			digitalWrite(motor_on_off_gpio, HIGH);
			
			delay((state == on ? move_down_time : move_up_time) * 1000);
			
			digitalWrite(motor_on_off_gpio, LOW);
			
			if (state == off) {
				digitalWrite(motor_direction_1_gpio, LOW);
				digitalWrite(motor_direction_2_gpio, LOW);
			}
		
		}
};