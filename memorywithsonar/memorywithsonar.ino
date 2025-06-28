// Motor driver pins
const int ENA = 10;  
const int IN1 = 9; 
const int IN2 = 8;   

const int ENB = 5;  
const int IN3 = 7; 
const int IN4 = 6; 
// Ultrasonic sensor pins
const int trigPin = 12;
const int echoPin = 13;

bool lastTurnLeft = true;

bool isMoving = false;
int motorSpeed = 200;  // PWM speed (0 to 255)

int obstacleThreshold = 15;  // in cm

void setup() {
  Serial.begin(9600);

  pinMode(ENA, OUTPUT);
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);

  pinMode(ENB, OUTPUT);
  pinMode(IN3, OUTPUT);
  pinMode(IN4, OUTPUT);

  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  stopMotors();
}




void loop() {
  int distance = getDistanceCm();
  // Serial.print("Distance: ");
  // Serial.print(distance);
  // Serial.println(" cm");






  if (Serial.available()) {
    char cmd = Serial.read();
    if (cmd == 's') {
      isMoving = true;
      Serial.println("Starting random movement...");
    } else if (cmd == 'x') {
      isMoving = false;
      stopMotors();
      Serial.println("Stopped.");
    }
  }
  if (isMoving) {
    randomMoving(distance);
  }

  delay(50);
}
//...random moving with obsticle avoid...//
void randomMoving(int distance) {
  int directionRight = random(0, 2);


  if (distance < obstacleThreshold) {
    stopMotors();
    Serial.println("Obstacle detected! Turning...");

 
    moveBackward();
    delay(500);
    stopMotors();
    delay(100);
    Serial.println(directionRight);

    if (directionRight == 1) {

      turnRight();
      lastTurnLeft = false;

    } else {
      turnLeft();
      lastTurnLeft = true;
    }

    delay(900);

    stopMotors();
    delay(100);
  } else {
    moveForward();
  }
}

int getDistanceCm() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long duration = pulseIn(echoPin, HIGH, 30000);  // 30ms timeout
  int distance = duration * 0.034 / 2;

  return distance;
}



void moveForward() {
  Serial.println("Moving Forward");
  digitalWrite(IN1, HIGH);  
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, LOW);  
  digitalWrite(IN4, HIGH);

  analogWrite(ENA, motorSpeed);
  analogWrite(ENB, motorSpeed);
}

void moveBackward() {
  Serial.println("Moving Backward");
  digitalWrite(IN1, LOW);  
  digitalWrite(IN2, HIGH);
  digitalWrite(IN3, HIGH);  
  digitalWrite(IN4, LOW);

  analogWrite(ENA, motorSpeed);
  analogWrite(ENB, motorSpeed);
}

void turnRight() {
  Serial.println("Turning Right");
  digitalWrite(IN1, HIGH);  
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, HIGH);  
  digitalWrite(IN4, LOW);

  analogWrite(ENA, motorSpeed);
  analogWrite(ENB, motorSpeed);
}

void turnLeft() {
  Serial.println("Turning Left");
  digitalWrite(IN1, LOW);  
  digitalWrite(IN2, HIGH);
  digitalWrite(IN3, LOW);  
  digitalWrite(IN4, HIGH);

  analogWrite(ENA, motorSpeed);
  analogWrite(ENB, motorSpeed);
}

void stopMotors() {
  Serial.println("Motors Stopped");
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, LOW);

  analogWrite(ENA, 0);
  analogWrite(ENB, 0);
}
