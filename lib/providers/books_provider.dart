import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/books_service.dart';
import '../models/book_model.dart';

class BooksProvider extends ChangeNotifier {
  List<BookModel> _books = [];
  List<BookModel> _filteredBooks = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedCategory;
  String? _searchQuery;
  int _currentPage = 0;
  final int _pageSize = 20;

  // Getters
  List<BookModel> get books => _filteredBooks.isEmpty ? _books : _filteredBooks;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedCategory => _selectedCategory;
  String? get searchQuery => _searchQuery;
  int get currentPage => _currentPage;

  final BooksService _booksService = BooksService();

  // Initialize
  Future<void> initialize() async {
    await loadBooks();
    await loadCategories();
  }

  // Load books
  Future<void> loadBooks({bool reset = false}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (reset) {
        _currentPage = 0;
        _books.clear();
      }

      final offset = _currentPage * _pageSize;
      final results = await _booksService.getAllBooks(
        limit: _pageSize,
        offset: offset,
        search: _searchQuery,
        category: _selectedCategory,
      );

      if (offset == 0) {
        _books = results.map((e) => BookModel.fromMap(e)).toList();
      } else {
        _books.addAll(results.map((e) => BookModel.fromMap(e)).toList());
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat buku: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load categories
  Future<void> loadCategories() async {
    try {
      _categories = await _booksService.getCategories();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  // Search books
  Future<void> searchBooks(String query) async {
    _searchQuery = query.isEmpty ? null : query;
    _currentPage = 0;
    await loadBooks(reset: true);
  }

  // Filter by category
  Future<void> filterByCategory(String? category) async {
    _selectedCategory = category;
    _currentPage = 0;
    await loadBooks(reset: true);
  }

  // Load more
  Future<void> loadMore() async {
    _currentPage++;
    await loadBooks();
  }

  // Get book by id
  Future<BookModel?> getBookById(int id) async {
    try {
      final result = await _booksService.getBookById(id);
      return result != null ? BookModel.fromMap(result) : null;
    } catch (e) {
      debugPrint('Error getting book: $e');
      return null;
    }
  }

  // Add book
  Future<bool> addBook(BookModel book) async {
    try {
      _isLoading = true;
      notifyListeners();

      final id = await _booksService.addBook(book.toMap());
      if (id > 0) {
        await loadBooks(reset: true);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Gagal menambah buku: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update book
  Future<bool> updateBook(BookModel book) async {
    try {
      _isLoading = true;
      notifyListeners();

      final success = await _booksService.updateBook(book.toMap());
      if (success) {
        await loadBooks(reset: true);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Gagal memperbarui buku: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete book
  Future<bool> deleteBook(int id) async {
    try {
      _isLoading = true;
      notifyListeners();

      final success = await _booksService.deleteBook(id);
      if (success) {
        await loadBooks(reset: true);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Gagal menghapus buku: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
