class Device {
  final int id;
  final String name;

  const Device({
    this.id = 0,
    this.name = "Unknown",
  });

  Device.fromJson(Map<String, dynamic> json)
      : this(
          id: json["id"],
          name: json["name"],
        );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode + name.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Device &&
      other.runtimeType == runtimeType &&
      other.id == id &&
      other.name == name;
}
