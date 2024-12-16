import 'package:intl/intl.dart';

String formatDuration(int milliseconds) {
  final seconds = (milliseconds / 1000).truncate();
  final minutes = (seconds / 60).truncate();
  final remainingSeconds = seconds % 60;
  return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
}

String formatToCustomDateTime(String isoDateTime) {
  DateTime dateTime = DateTime.parse(isoDateTime);

  String formattedDate = DateFormat('HH:mm, dd.MM.yyyy').format(dateTime);

  return formattedDate;
}