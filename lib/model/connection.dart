class Connection {
  final String name;
  final ConnectionType type;
}

enum ConnectionType {
  mqtt,
  remote,
  local,
  alexa,
  google,
}
