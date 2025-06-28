import 'package:usb_serial/usb_serial.dart';
import 'dart:typed_data';

class MotorController {
  UsbPort? _port;

  // Connect to the USB device
  Future<String> connect() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (devices.isNotEmpty) {
      _port = await devices[0].create();
      bool isOpen = await _port!.open();

      if (isOpen) {
        await _port!.setPortParameters(
          9600, // Baud rate
          UsbPort.DATABITS_8, // Data bits
          UsbPort.STOPBITS_1, // Stop bits
          UsbPort.PARITY_NONE, // Parity
        );
        return "Connected"; // Return success message
      } else {
        return "Failed to open port"; // Return error message if failed to open
      }
    } else {
      return "No device found"; // Return error message if no device is found
    }
  }

  // Send a command to the motor
  void sendCommand(String command) {
    if (_port != null) {
      _port!.write(Uint8List.fromList(command.codeUnits + '\n'.codeUnits));
    }
  }

  // Dispose and close the port
  void dispose() {
    _port?.close();
  }
}
