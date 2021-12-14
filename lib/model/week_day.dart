enum WeekDay { lun, mar, mer, gio, ven, sab, dom }

extension WeekDayExtension on WeekDay {
  String get name {
    return ["Lun", "Mar", "Mer", "Gio", "Ven", "Sab", "Dom"][index];
  }
}
