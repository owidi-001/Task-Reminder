String getDate() {
  DateTime date = DateTime.now();
  List<String> months = [
    "Jan",
    "Feb",
    "March",
    "April",
    "May",
    "June",
    "July",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  return "${date.day} ${months[date.month - 1]}";
}
