import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../data/models/preapproved_visitor_model.dart';
import '../data/models/visitor_model.dart';
import '../providers/visitor_provider.dart';
import 'pass_screen.dart';

class VisitorRegistrationScreen extends ConsumerStatefulWidget {
  final PreApprovedVisitor? preApprovedVisitor;

  const VisitorRegistrationScreen({super.key, this.preApprovedVisitor});

  @override
  ConsumerState<VisitorRegistrationScreen> createState() => _VisitorRegistrationScreenState();
}

class _VisitorRegistrationScreenState extends ConsumerState<VisitorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cnicController = TextEditingController();
  final _contactController = TextEditingController();
  final _purposeController = TextEditingController();
  XFile? _visitorPhoto;
  bool _isPreApproved = false;

  @override
  void initState() {
    super.initState();
    if (widget.preApprovedVisitor != null) {
      final data = widget.preApprovedVisitor!;
      _nameController.text = data.name;
      _cnicController.text = data.cnic;
      _purposeController.text = data.purpose;
      _isPreApproved = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cnicController.dispose();
    _contactController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          _visitorPhoto = photo;
        });
      }
    } catch (e) {
      debugPrint("Error capturing photo: $e");
    }
  }

  void _checkInVisitor() {
    if (_formKey.currentState!.validate()) {
      if (_visitorPhoto == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please capture a visitor photo.')),
        );
        return;
      }

      // Create the new visitor model
      final newVisitor = Visitor(
        name: _nameController.text,
        cnic: _cnicController.text,
        contact: _contactController.text,
        purpose: _purposeController.text,
        photoPath: _visitorPhoto!.path, // Use the path string
        checkInTime: DateTime.now(),
        wasPreApproved: _isPreApproved,
      );

      // Call the notifier to handle the logic
      ref.read(visitorProvider.notifier).checkInVisitor(
            newVisitor,
            widget.preApprovedVisitor,
          );

      // Pop this screen and navigate to the pass screen
      Navigator.pop(context); // Pop registration
      Navigator.push( // Push pass screen
        context,
        MaterialPageRoute(
          builder: (context) => VisitorPassScreen(visitor: newVisitor),
        ),
      );
    }
  }

  ImageProvider? _getPreviewImage() {
    if (_visitorPhoto == null) return null;
    if (kIsWeb) {
      return NetworkImage(_visitorPhoto!.path);
    } else {
      return FileImage(File(_visitorPhoto!.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isPreApproved ? 'Express Check-In' : 'Register New Visitor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _getPreviewImage(),
                      child: _visitorPhoto == null
                          ? const Icon(Icons.person, size: 60, color: Colors.white)
                          : null,
                    ),
                    IconButton.filled(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: _capturePhoto,
                      style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                readOnly: _isPreApproved,
                decoration: const InputDecoration(labelText: "Visitor's Name"),
                validator: (value) => value!.isEmpty ? "Name cannot be empty" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cnicController,
                readOnly: _isPreApproved,
                decoration: const InputDecoration(labelText: "CNIC Number"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "CNIC cannot be empty" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: "Contact Info (Required)"),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? "Contact cannot be empty" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _purposeController,
                readOnly: _isPreApproved,
                decoration: const InputDecoration(labelText: "Purpose of Visit"),
                maxLines: 2,
                validator: (value) => value!.isEmpty ? "Purpose cannot be empty" : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _checkInVisitor,
                icon: const Icon(Icons.receipt_long),
                label: const Text('Generate Pass'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Colors.teal[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}