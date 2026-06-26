import 'package:flutter/material.dart';
import 'database/database_helper.dart';

class ReportService {
  static final ReportService _instance = ReportService._internal();

  factory ReportService() {
    return _instance;
  }

  ReportService._internal();

  // Get monthly statistics
  Future<Map<String, dynamic>> getMonthlyStat(int month, int year) async {
    try {
      final db = DatabaseHelper.instance;

      final borrowCount = await db.rawQuery(
        '''SELECT COUNT(*) as count FROM borrowing 
           WHERE strftime('%m', borrowDate) = ? AND strftime('%Y', borrowDate) = ?''',
        [month.toString().padLeft(2, '0'), year.toString()],
      );

      final returnCount = await db.rawQuery(
        '''SELECT COUNT(*) as count FROM returning 
           WHERE strftime('%m', returnDate) = ? AND strftime('%Y', returnDate) = ?''',
        [month.toString().padLeft(2, '0'), year.toString()],
      );

      final totalFine = await db.rawQuery(
        '''SELECT SUM(amount) as total FROM fine 
           WHERE strftime('%m', createdAt) = ? AND strftime('%Y', createdAt) = ?''',
        [month.toString().padLeft(2, '0'), year.toString()],
      );

      return {
        'borrowCount': borrowCount.first['count'] as int,
        'returnCount': returnCount.first['count'] as int,
        'totalFine': (totalFine.first['total'] as num?)?.toDouble() ?? 0.0,
      };
    } catch (e) {
      debugPrint('Error getting monthly stats: $e');
      return {'borrowCount': 0, 'returnCount': 0, 'totalFine': 0.0};
    }
  }

  // Get yearly statistics
  Future<Map<String, dynamic>> getYearlyStat(int year) async {
    try {
      final db = DatabaseHelper.instance;

      final borrowCount = await db.rawQuery(
        '''SELECT COUNT(*) as count FROM borrowing 
           WHERE strftime('%Y', borrowDate) = ?''',
        [year.toString()],
      );

      final returnCount = await db.rawQuery(
        '''SELECT COUNT(*) as count FROM returning 
           WHERE strftime('%Y', returnDate) = ?''',
        [year.toString()],
      );

      final totalFine = await db.rawQuery(
        '''SELECT SUM(amount) as total FROM fine 
           WHERE strftime('%Y', createdAt) = ?''',
        [year.toString()],
      );

      final newMembers = await db.rawQuery(
        '''SELECT COUNT(*) as count FROM members 
           WHERE strftime('%Y', createdAt) = ?''',
        [year.toString()],
      );

      final newBooks = await db.rawQuery(
        '''SELECT COUNT(*) as count FROM books 
           WHERE strftime('%Y', createdAt) = ?''',
        [year.toString()],
      );

      return {
        'borrowCount': borrowCount.first['count'] as int,
        'returnCount': returnCount.first['count'] as int,
        'totalFine': (totalFine.first['total'] as num?)?.toDouble() ?? 0.0,
        'newMembers': newMembers.first['count'] as int,
        'newBooks': newBooks.first['count'] as int,
      };
    } catch (e) {
      debugPrint('Error getting yearly stats: $e');
      return {
        'borrowCount': 0,
        'returnCount': 0,
        'totalFine': 0.0,
        'newMembers': 0,
        'newBooks': 0,
      };
    }
  }

  // Get top borrowed books
  Future<List<Map<String, dynamic>>> getTopBorrowedBooks({int limit = 10}) async {
    try {
      final db = DatabaseHelper.instance;
      return await db.rawQuery(
        '''SELECT b.*, COUNT(br.id) as borrow_count
           FROM books b
           LEFT JOIN borrowing br ON b.id = br.bookId
           GROUP BY b.id
           ORDER BY borrow_count DESC
           LIMIT ?''',
        [limit],
      );
    } catch (e) {
      debugPrint('Error getting top borrowed books: $e');
      return [];
    }
  }

  // Get active borrowing by category
  Future<List<Map<String, dynamic>>> getBorrowingByCategory() async {
    try {
      final db = DatabaseHelper.instance;
      return await db.rawQuery(
        '''SELECT b.category, COUNT(br.id) as count
           FROM books b
           LEFT JOIN borrowing br ON b.id = br.bookId AND br.status = 'active'
           GROUP BY b.category
           ORDER BY count DESC''',
      );
    } catch (e) {
      debugPrint('Error getting borrowing by category: $e');
      return [];
    }
  }

  // Get member activity
  Future<List<Map<String, dynamic>>> getMemberActivity({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final db = DatabaseHelper.instance;
      return await db.rawQuery(
        '''SELECT m.*, COUNT(br.id) as total_borrow
           FROM members m
           LEFT JOIN borrowing br ON m.id = br.memberId
           GROUP BY m.id
           ORDER BY total_borrow DESC
           LIMIT ? OFFSET ?''',
        [limit, offset],
      );
    } catch (e) {
      debugPrint('Error getting member activity: $e');
      return [];
    }
  }
}
