# SIPERPUS PRO - Development Guide

## Panduan Pengembangan

Dokumen ini berisi panduan untuk developer yang ingin berkontribusi pada proyek SIPERPUS PRO.

## 🏗️ Arsitektur Proyek

SIPERPUS PRO menggunakan **Clean Architecture** dengan pembagian layer:

### 1. **Models Layer** (`lib/models/`)
Mendefinisikan struktur data aplikasi.
- `user_model.dart` - Data user (Admin/Siswa)
- `book_model.dart` - Data buku
- `member_model.dart` - Data anggota
- `transaction_model.dart` - Data transaksi

### 2. **Services Layer** (`lib/services/`)
Menangani operasi database dan API.
- `books_service.dart` - CRUD buku
- `members_service.dart` - CRUD anggota
- `borrowing_service.dart` - Transaksi peminjaman
- `fine_service.dart` - Manajemen denda
- `report_service.dart` - Laporan dan statistik

### 3. **Providers Layer** (`lib/providers/`)
State management dengan Provider.
- `auth_provider.dart` - Autentikasi user
- `theme_provider.dart` - Dark/Light mode
- `books_provider.dart` - State buku
- `members_provider.dart` - State anggota

### 4. **Screens Layer** (`lib/screens/`)
UI screens untuk setiap fitur.
```
screens/
├── auth/ - Login & authentication
├── admin/ - Admin dashboard & screens
├── student/ - Student dashboard & screens
├── books/ - Books list & management
├── members/ - Members list & management
├── borrowing/ - Borrowing transactions
├── report/ - Reports & analytics
├── profile/ - User profile
└── settings/ - App settings
```

### 5. **Widgets Layer** (`lib/widgets/`)
Reusable UI components.
- `custom_button.dart` - Button components
- `custom_text_field.dart` - Input fields
- `custom_card.dart` - Card components
- `custom_appbar.dart` - App bar & navigation
- `custom_dialog.dart` - Dialog & snackbar
- `loading_widget.dart` - Loading states

### 6. **Utilities Layer** (`lib/utils/`)
Helper functions dan utilities.
- `validators.dart` - Input validation
- `date_formatter.dart` - Date formatting

## 📝 Coding Standards

### Naming Convention
```dart
// Classes - PascalCase
class UserModel { }

// Functions & Variables - camelCase
void fetchUserData() { }
int userId = 1;

// Constants - lowerCamelCase
const String apiEndpoint = 'https://api.example.com';

// Private members - underscore prefix
class _PrivateClass { }
void _privateMethod() { }

// File names - snake_case
user_model.dart
books_service.dart
auth_provider.dart
```

### Code Style
```dart
// Always specify return types
String getUserName() => 'John Doe';
void printMessage(String msg) => print(msg);

// Use const where possible
const buttonPadding = EdgeInsets.all(16);

// Use cascade notation
user.firstName = 'John'
    ..lastName = 'Doe'
    ..email = 'john@example.com';

// Use trailing comma for better formatting
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Text('Hello'),
  );
}
```

## 🔄 State Management with Provider

### Creating a Provider
```dart
class MyProvider extends ChangeNotifier {
  String _data = '';
  
  String get data => _data;
  
  Future<void> fetchData() async {
    _data = 'fetched data';
    notifyListeners();
  }
}
```

### Using Provider in Widget
```dart
// Read only
final data = context.read<MyProvider>().data;

// Listen to changes
Consumer<MyProvider>(
  builder: (context, provider, child) {
    return Text(provider.data);
  },
)

// Watch for changes
final provider = context.watch<MyProvider>();
```

## 🗄️ Database Operations

### Adding Data
```dart
Future<int> addBook(BookModel book) async {
  final db = DatabaseHelper.instance;
  return await db.insert('books', book.toMap());
}
```

### Querying Data
```dart
Future<List<BookModel>> getAllBooks() async {
  final db = DatabaseHelper.instance;
  final results = await db.rawQuery('SELECT * FROM books');
  return results.map((e) => BookModel.fromMap(e)).toList();
}
```

### Updating Data
```dart
Future<bool> updateBook(BookModel book) async {
  final db = DatabaseHelper.instance;
  final result = await db.update('books', book.toMap());
  return result > 0;
}
```

### Deleting Data
```dart
Future<bool> deleteBook(int id) async {
  final db = DatabaseHelper.instance;
  final result = await db.delete('books', id);
  return result > 0;
}
```

## 🎨 UI/UX Guidelines

### Colors
```dart
// Use theme colors from AppTheme
AppTheme.primary     // #1565C0 (Biru)
AppTheme.secondary   // #42A5F5 (Biru Muda)
AppTheme.background  // #F5F7FA (Abu-abu Terang)
AppTheme.success     // #4CAF50 (Hijau)
AppTheme.warning     // #FFC107 (Kuning)
AppTheme.error       // #F44336 (Merah)
```

### Spacing
```dart
// Use consistent spacing
const SizedBox(height: 8)  // Small
const SizedBox(height: 12) // Medium
const SizedBox(height: 16) // Large
const SizedBox(height: 24) // Extra Large
```

### Border Radius
```dart
BorderRadius.circular(8)   // Small
BorderRadius.circular(12)  // Medium
BorderRadius.circular(16)  // Large
BorderRadius.circular(25)  // Extra Large (cards)
```

## ✅ Testing Checklist

- [ ] Input validation works correctly
- [ ] Database operations successful
- [ ] State management updates UI
- [ ] Error handling displays proper messages
- [ ] Loading states show shimmer/skeleton
- [ ] Empty states display correctly
- [ ] Navigation works between screens
- [ ] Responsive design on different screen sizes
- [ ] Dark/Light mode switching works
- [ ] No console errors or warnings

## 🐛 Debugging Tips

### View Database
```dart
// Add this in main.dart during development
if (kDebugMode) {
  print('Database path: ${await getDatabasesPath()}');
}
```

### Check State Changes
```dart
class DebugProvider extends ChangeNotifier {
  @override
  void notifyListeners() {
    debugPrint('Provider notified');
    super.notifyListeners();
  }
}
```

### Widget Tree Inspection
```
Flutter DevTools > Widgets Inspector
- Inspect widget tree
- Check properties
- Detect performance issues
```

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [Provider Package](https://pub.dev/packages/provider)
- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [Material Design 3](https://m3.material.io/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📞 Support

For questions or issues, please create an issue on GitHub.

---

Last Updated: June 26, 2024
