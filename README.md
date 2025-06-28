# 🚶⏰ Walking Alarm Clock

A creative alarm clock that literally walks away until you get out of bed to stop it! Powered by an **Arduino Uno** and controlled by a **custom Flutter app** via **USB serial communication**.

---

## 📦 Features

- ⏰ Set alarm time from a custom **Flutter Android app**
- 🤖 Clock starts moving on wheels when alarm rings
- 🚧 Uses ultrasonic sensor to detect and avoid obstacles
- 🔌 Communicates with Arduino Uno over USB (Serial)
- 🛑 Forces the user to physically stop the clock

---

## 🛠️ Hardware Components

- Arduino Uno
- 4x DC motors
- 1x L298N Motor Driver Modules
- 1x Ultrasonic Sensor (HC-SR04)
- USB OTG cable for phone-Arduino connection
- Power supply (battery pack or power bank)
- Chassis with wheels

---

## 📱 Flutter App

- Built using **Flutter (Dart)**
- Supports Android devices with **USB OTG**
- Uses `usb_serial` package for serial communication
- Clean, minimal UI for setting alarms and sending commands
- Sends alarm trigger command to Arduino over USB serial

---

## 🔧 How It Works

1. Set the alarm time using the Flutter app.
2. When the alarm time hits, app sends a signal to Arduino via USB.
3. Arduino activates the motors and starts moving.
4. Ultrasonic sensor avoids obstacles by changing direction.
5. The user must physically catch the alarm clock to turn it off!

---


