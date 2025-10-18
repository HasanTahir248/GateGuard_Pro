import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/models/preapproved_visitor_model.dart';
import '../data/models/visitor_model.dart';
import '../providers/visitor_provider.dart';
import 'pass_screen.dart';
import 'registration_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Helper method to get the correct image provider based on platform
  ImageProvider _getVisitorImage(String photoPath) {
    if (kIsWeb) {
      return NetworkImage(photoPath);
    } else {
      return FileImage(File(photoPath));
    }
  }

  // Navigation logic is now simpler. It just opens the screen.
  // The provider will handle the logic when a visitor is created.
  void _navigateToRegister({PreApprovedVisitor? preApprovedData}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VisitorRegistrationScreen(
          preApprovedVisitor: preApprovedData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider to get the current state
    final state = ref.watch(visitorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitor Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.login), text: 'Checked-In'),
            Tab(icon: Icon(Icons.playlist_add_check), text: 'Pre-Approved'),
          ],
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Pass the lists from the state to the build methods
                _buildCheckedInList(state.visitorLog),
                _buildPreApprovedList(state.preApprovedLog),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToRegister(), // For Walk-ins
        label: const Text('Walk-in Visitor'),
        icon: const Icon(Icons.person_add),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildCheckedInList(List<Visitor> visitorLog) {
    final checkedInVisitors = visitorLog.where((v) => v.checkOutTime == null).toList();

    if (checkedInVisitors.isEmpty) {
      return const Center(
        child: Text('No visitors currently checked in.',
            style: TextStyle(fontSize: 18, color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: checkedInVisitors.length,
      itemBuilder: (context, index) {
        final visitor = checkedInVisitors[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: _getVisitorImage(visitor.photoPath),
            ),
            title: Text(visitor.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Checked In: ${DateFormat.yMd().add_jm().format(visitor.checkInTime)}'),
            trailing: Icon(
              visitor.wasPreApproved ? Icons.check_circle : Icons.arrow_forward_ios,
              color: visitor.wasPreApproved ? Colors.green : Colors.grey,
            ),
            onTap: () {
              // Navigate to the pass screen for this visitor
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VisitorPassScreen(visitor: visitor),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPreApprovedList(List<PreApprovedVisitor> preApprovedLog) {
    if (preApprovedLog.isEmpty) {
      return const Center(
        child: Text('No pre-approved guests for today.',
            style: TextStyle(fontSize: 18, color: Colors.grey)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: preApprovedLog.length,
      itemBuilder: (context, index) {
        final visitor = preApprovedLog[index];
        return Card(
          elevation: 2,
          color: Colors.teal[50],
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.person, color: Colors.teal),
            title: Text(visitor.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Host: ${visitor.residentHost}'),
            trailing: ElevatedButton(
              child: const Text('Check-In'),
              // Pass pre-approved data to the registration screen
              onPressed: () => _navigateToRegister(preApprovedData: visitor),
            ),
          ),
        );
      },
    );
  }
}