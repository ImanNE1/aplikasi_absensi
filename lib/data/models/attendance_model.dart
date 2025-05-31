class Attendance {
  final int id;
  final int userId;
  final int? barcodeId;
  final DateTime date;
  final DateTime? timeIn;
  final DateTime? timeOut;
  final int? shiftId;
  final String status; // present, late, excused, sick, absent

  Attendance({
    required this.id,
    required this.userId,
    this.barcodeId,
    required this.date,
    this.timeIn,
    this.timeOut,
    this.shiftId,
    required this.status,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      barcodeId: json['barcode_id'] as int?,
      date: DateTime.parse(json['date'] as String),
      timeIn: json['time_in'] != null
          ? DateTime.parse(json['time_in'] as String)
          : null,
      timeOut: json['time_out'] != null
          ? DateTime.parse(json['time_out'] as String)
          : null,
      shiftId: json['shift_id'] as int?,
      status: json['status'] as String,
    );
  }
}
