# Guitartist

A Flutter app that provides exercises about music theory, including the concepts of notes, intervals, scales and chords.

<div align = "center">
  <img src = "assets/imgs/menu light.png" alt = "Menu do app Guitartist" width = "20%">
  <p><em>Guitartist - Main Menu</em></p>
</div>

## Running

First, create a file called "connection.dart" in the directory "/lib/connection". This file should have this structure:

```dart
abstract class Connection {
  static final String _serverIpAddress = "ServerIPAddress"; // Put the Server IP here
  static final String _port = "ServerPort"; // Put the port used in the server here

  static String get serverIpAddress => _serverIpAddress;
  static String get port => _port;
}
```

To run this project, you need to have the Guitartist Server running, which can be found at <a href = "https://github.com/Rafael-Rech/guitartist-backend"> https://github.com/Rafael-Rech/guitartist-backend </a>.

After setting the server, you can now run Guitartist with

```bash
$ flutter run
```
