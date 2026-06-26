import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/report_service.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/loading_widget.dart';
import '../../config/theme/app_theme.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ReportService _reportService = ReportService();
  DateTime _selectedDate = DateTime.now();
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Laporan',
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Date selector
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() => _selectedDate = date);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              '${_selectedDate.month}/${_selectedDate.year}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() => _selectedTab = 0);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _selectedTab == 0
                                ? AppTheme.primary
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Bulanan',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _selectedTab == 0
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() => _selectedTab = 1);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _selectedTab == 1
                                ? AppTheme.primary
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Tahunan',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _selectedTab == 1
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Report content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _selectedTab == 0
                  ? _buildMonthlyReport()
                  : _buildYearlyReport(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyReport() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _reportService.getMonthlyStat(_selectedDate.month, _selectedDate.year),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }

        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!;

        return Column(
          children: [
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                StatisticCard(
                  title: 'Peminjaman',
                  value: data['borrowCount'].toString(),
                  icon: Icons.library_add,
                  iconColor: Colors.blue,
                ),
                StatisticCard(
                  title: 'Pengembalian',
                  value: data['returnCount'].toString(),
                  icon: Icons.check_circle,
                  iconColor: Colors.green,
                ),
                StatisticCard(
                  title: 'Total Denda',
                  value: 'Rp${(data['totalFine'] ?? 0).toStringAsFixed(0)}',
                  icon: Icons.money,
                  iconColor: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Detail Transaksi',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                children: [
                  _buildReportRow(
                    'Total Peminjaman',
                    data['borrowCount'].toString(),
                  ),
                  const Divider(),
                  _buildReportRow(
                    'Total Pengembalian',
                    data['returnCount'].toString(),
                  ),
                  const Divider(),
                  _buildReportRow(
                    'Total Denda',
                    'Rp${(data['totalFine'] ?? 0).toStringAsFixed(0)}',
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildYearlyReport() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _reportService.getYearlyStat(_selectedDate.year),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }

        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!;

        return Column(
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                StatisticCard(
                  title: 'Peminjaman',
                  value: data['borrowCount'].toString(),
                  icon: Icons.library_add,
                  iconColor: Colors.blue,
                ),
                StatisticCard(
                  title: 'Pengembalian',
                  value: data['returnCount'].toString(),
                  icon: Icons.check_circle,
                  iconColor: Colors.green,
                ),
                StatisticCard(
                  title: 'Anggota Baru',
                  value: data['newMembers'].toString(),
                  icon: Icons.person_add,
                  iconColor: Colors.purple,
                ),
                StatisticCard(
                  title: 'Buku Baru',
                  value: data['newBooks'].toString(),
                  icon: Icons.library_add_check,
                  iconColor: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Ringkasan Tahunan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                children: [
                  _buildReportRow(
                    'Total Peminjaman',
                    data['borrowCount'].toString(),
                  ),
                  const Divider(),
                  _buildReportRow(
                    'Total Pengembalian',
                    data['returnCount'].toString(),
                  ),
                  const Divider(),
                  _buildReportRow(
                    'Anggota Baru',
                    data['newMembers'].toString(),
                  ),
                  const Divider(),
                  _buildReportRow(
                    'Buku Baru',
                    data['newBooks'].toString(),
                  ),
                  const Divider(),
                  _buildReportRow(
                    'Total Denda',
                    'Rp${(data['totalFine'] ?? 0).toStringAsFixed(0)}',
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReportRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
