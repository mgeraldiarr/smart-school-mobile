enum ScheduleStatus { upcoming, ongoing, finished }

class TeacherSchedule {
  final int id;
  final int classId;
  final String className;
  final int subjectId;
  final String subjectName;
  final String dayOfWeek;
  final String startTime; // Format "HH:mm" dari backend
  final String endTime;

  const TeacherSchedule({
    required this.id,
    required this.classId,
    required this.className,
    required this.subjectId,
    required this.subjectName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory TeacherSchedule.fromJson(Map<String, dynamic> json) {
    return TeacherSchedule(
      id: json['id'] as int,
      classId: json['class_id'] as int,
      className: json['class_name'] as String? ?? '-',
      subjectId: json['subject_id'] as int,
      subjectName: json['subject_name'] as String? ?? '-',
      dayOfWeek: json['day_of_week'] as String? ?? '',
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
    );
  }

  int get startMinutes => _toMinutes(startTime);
  int get endMinutes => _toMinutes(endTime);
  int get durationMinutes => endMinutes - startMinutes;

  // Tampilan jam ala Indonesia: "07.00 - 08.30"
  String get timeRange =>
      '${startTime.replaceAll(':', '.')} - ${endTime.replaceAll(':', '.')}';

  ScheduleStatus statusAt(DateTime now) {
    final nowMinutes = now.hour * 60 + now.minute;
    if (nowMinutes < startMinutes) return ScheduleStatus.upcoming;
    if (nowMinutes < endMinutes) return ScheduleStatus.ongoing;
    return ScheduleStatus.finished;
  }

  static int _toMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}
