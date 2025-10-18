import 'dart:convert';
import 'package:flutter/services.dart';
import 'models/preapproved_visitor_model.dart';
import 'models/visitor_model.dart';

class VisitorRepository {
  Future<List<Visitor>> getVisitors() async {
    // In a real app, this would be an API call.
    final String response = await rootBundle.loadString('assets/data/visitors.json');
    final data = jsonDecode(response) as List<dynamic>;
    return data.map((json) => Visitor.fromJson(json)).toList();
  }

  Future<List<PreApprovedVisitor>> getPreApproved() async {
    final String response = await rootBundle.loadString('assets/data/preapproved.json');
    final data = jsonDecode(response) as List<dynamic>;
    return data.map((json) => PreApprovedVisitor.fromJson(json)).toList();
  }
}