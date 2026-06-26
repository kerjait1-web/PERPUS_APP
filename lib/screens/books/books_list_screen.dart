import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/books_provider.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_widget.dart';
import '../../config/theme/app_theme.dart';

class BooksListScreen extends StatefulWidget {
  const BooksListScreen({Key? key}) : super(key: key);

  @override
  State<BooksListScreen> createState() => _BooksListScreenState();
}

class _BooksListScreenState extends State<BooksListScreen> {
  final _searchController = TextEditingController();
  String? _selectedCategory;
  bool _isGrid = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<BooksProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Koleksi Buku',
        elevation: 0,
      ),
      body: Consumer<BooksProvider>(
        builder: (context, booksProvider, _) {
          return Column(
            children: [
              // Search dan filter
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Search box
                    SearchBox(
                      hint: 'Cari buku, penulis...',
                      controller: _searchController,
                      onChanged: (value) {
                        booksProvider.searchBooks(value);
                      },
                    ),
                    const SizedBox(height: 12),

                    // Category filter
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() => _selectedCategory = null);
                              booksProvider.filterByCategory(null);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: _selectedCategory == null
                                    ? AppTheme.primary
                                    : Colors.transparent,
                                border: Border.all(
                                  color: _selectedCategory == null
                                      ? AppTheme.primary
                                      : Colors.grey.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'Semua',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _selectedCategory == null
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          ...booksProvider.categories.map((category) {
                            final isSelected = _selectedCategory == category;
                            return GestureDetector(
                              onTap: () {
                                setState(() => _selectedCategory = category);
                                booksProvider.filterByCategory(category);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.primary
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.primary
                                        : Colors.grey.withOpacity(0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  category,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // View toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: ${booksProvider.books.length} buku',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.list,
                                color: !_isGrid
                                    ? AppTheme.primary
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() => _isGrid = false);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.grid_view,
                                color: _isGrid
                                    ? AppTheme.primary
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() => _isGrid = true);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Books list or grid
              Expanded(
                child: booksProvider.isLoading && booksProvider.books.isEmpty
                    ? const ListShimmerLoading()
                    : booksProvider.books.isEmpty
                        ? EmptyStateWidget(
                            icon: Icons.book_outlined,
                            title: 'Buku Tidak Ditemukan',
                            message: 'Coba ubah filter atau cari dengan kata kunci lain',
                            onRetry: () {
                              booksProvider.initialize();
                            },
                          )
                        : _isGrid
                            ? GridView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.65,
                                ),
                                itemCount: booksProvider.books.length,
                                itemBuilder: (context, index) {
                                  final book = booksProvider.books[index];
                                  return BookCard(
                                    title: book.title,
                                    author: book.author,
                                    onTap: () {},
                                    onFavoriteTap: () {},
                                  );
                                },
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                itemCount: booksProvider.books.length,
                                itemBuilder: (context, index) {
                                  final book = booksProvider.books[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: CustomCard(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(Icons.book),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  book.title,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  book.author,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Stok: ${book.stock}',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                    color: book.stock > 0
                                                        ? Colors.green
                                                        : Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.favorite_border,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
