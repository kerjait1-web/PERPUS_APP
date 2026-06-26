class BorrowingModel {
  final int? id;
  final int memberId;
  final int bookId;
  final DateTime borrowDate;
  final DateTime dueDate;
  final String status;
  final String? memberName;
  final String? bookTitle;

  BorrowingModel({
    this.id,
    required this.memberId,
    required this.bookId,
    required this.borrowDate,
    required this.dueDate,
    this.status = 'active',
    this.memberName,
    this.bookTitle,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memberId': memberId,
      'bookId': bookId,
      'borrowDate': borrowDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'status': status,
    };
  }

  factory BorrowingModel.fromMap(Map<String, dynamic> map) {
    return BorrowingModel(
      id: map['id'],
      memberId: map['memberId'],
      bookId: map['bookId'],
      borrowDate: DateTime.parse(map['borrowDate']),
      dueDate: DateTime.parse(map['dueDate']),
      status: map['status'] ?? 'active',
      memberName: map['memberName'],
      bookTitle: map['bookTitle'],
    );
  }

  BorrowingModel copyWith({
    int? id,
    int? memberId,
    int? bookId,
    DateTime? borrowDate,
    DateTime? dueDate,
    String? status,
    String? memberName,
    String? bookTitle,
  }) {
    return BorrowingModel(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      bookId: bookId ?? this.bookId,
      borrowDate: borrowDate ?? this.borrowDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      memberName: memberName ?? this.memberName,
      bookTitle: bookTitle ?? this.bookTitle,
    );
  }
}

class ReturningModel {
  final int? id;
  final int borrowingId;
  final DateTime returnDate;
  final String? condition;
  final String? notes;

  ReturningModel({
    this.id,
    required this.borrowingId,
    required this.returnDate,
    this.condition,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'borrowingId': borrowingId,
      'returnDate': returnDate.toIso8601String(),
      'condition': condition,
      'notes': notes,
    };
  }

  factory ReturningModel.fromMap(Map<String, dynamic> map) {
    return ReturningModel(
      id: map['id'],
      borrowingId: map['borrowingId'],
      returnDate: DateTime.parse(map['returnDate']),
      condition: map['condition'],
      notes: map['notes'],
    );
  }

  ReturningModel copyWith({
    int? id,
    int? borrowingId,
    DateTime? returnDate,
    String? condition,
    String? notes,
  }) {
    return ReturningModel(
      id: id ?? this.id,
      borrowingId: borrowingId ?? this.borrowingId,
      returnDate: returnDate ?? this.returnDate,
      condition: condition ?? this.condition,
      notes: notes ?? this.notes,
    );
  }
}

class FineModel {
  final int? id;
  final int borrowingId;
  final double amount;
  final String? reason;
  final DateTime? paidDate;
  final String status;

  FineModel({
    this.id,
    required this.borrowingId,
    required this.amount,
    this.reason,
    this.paidDate,
    this.status = 'unpaid',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'borrowingId': borrowingId,
      'amount': amount,
      'reason': reason,
      'paidDate': paidDate?.toIso8601String(),
      'status': status,
    };
  }

  factory FineModel.fromMap(Map<String, dynamic> map) {
    return FineModel(
      id: map['id'],
      borrowingId: map['borrowingId'],
      amount: map['amount'],
      reason: map['reason'],
      paidDate: map['paidDate'] != null ? DateTime.parse(map['paidDate']) : null,
      status: map['status'] ?? 'unpaid',
    );
  }

  FineModel copyWith({
    int? id,
    int? borrowingId,
    double? amount,
    String? reason,
    DateTime? paidDate,
    String? status,
  }) {
    return FineModel(
      id: id ?? this.id,
      borrowingId: borrowingId ?? this.borrowingId,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      paidDate: paidDate ?? this.paidDate,
      status: status ?? this.status,
    );
  }
}
