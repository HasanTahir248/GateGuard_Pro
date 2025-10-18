import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../data/models/visitor_model.dart';
import '../providers/visitor_provider.dart';

class VisitorPassScreen extends ConsumerWidget {
  final Visitor visitor;

  const VisitorPassScreen({super.key, required this.visitor});

  void _performCheckOut(BuildContext context, WidgetRef ref) {
    // Call the notifier to handle the logic
    ref.read(visitorProvider.notifier).checkOutVisitor(visitor.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${visitor.name} checked out successfully.'),
        backgroundColor: Colors.green,
      ),
    );
    // Pop back to the home screen
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Widget _getVisitorImageWidget(String photoPath) {
    if (kIsWeb) {
      return Image.network(photoPath, width: 100, height: 100, fit: BoxFit.cover);
    } else {
      return Image.file(File(photoPath), width: 100, height: 100, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get the most up-to-date version of this visitor
    final latestVisitorState = ref.watch(visitorProvider).visitorLog;
    // Find our specific visitor in the log
    final visitor = latestVisitorState.firstWhere((v) => v.id == this.visitor.id, orElse: () => this.visitor);
    
    bool isCheckedOut = visitor.checkOutTime != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitor Pass'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Removed logo for simplicity, add back if you have 'assets/logo.png'
                        Icon(Icons.shield, size: 40, color: Colors.teal),
                        SizedBox(width: 12),
                        Text('Society Pass', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _getVisitorImageWidget(visitor.photoPath),
                        ),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: QrImageView(data: visitor.id, version: QrVersions.auto, size: 100.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow('Name:', visitor.name),
                    _buildInfoRow('CNIC:', visitor.cnic),
                    _buildInfoRow('Checked In:', DateFormat.yMd().add_jm().format(visitor.checkInTime)),
                    if (isCheckedOut)
                      _buildInfoRow('Checked Out:', DateFormat.yMd().add_jm().format(visitor.checkOutTime!)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            if (!isCheckedOut)
              ElevatedButton.icon(
                onPressed: () => _performCheckOut(context, ref),
                icon: const Icon(Icons.logout),
                label: const Text('Scan & Check-Out'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}