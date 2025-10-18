import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/models/preapproved_visitor_model.dart';
import '../data/models/visitor_model.dart';
import '../data/visitor_repository.dart';

// 1. Define the State class
class VisitorState {
  final List<Visitor> visitorLog;
  final List<PreApprovedVisitor> preApprovedLog;
  final bool isLoading;

  VisitorState({
    this.visitorLog = const [],
    this.preApprovedLog = const [],
    this.isLoading = true,
  });

  VisitorState copyWith({
    List<Visitor>? visitorLog,
    List<PreApprovedVisitor>? preApprovedLog,
    bool? isLoading,
  }) {
    return VisitorState(
      visitorLog: visitorLog ?? this.visitorLog,
      preApprovedLog: preApprovedLog ?? this.preApprovedLog,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// 2. Create the Notifier (our ViewModel)
class VisitorNotifier extends StateNotifier<VisitorState> {
  final VisitorRepository _repository;

  VisitorNotifier(this._repository) : super(VisitorState()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final visitors = await _repository.getVisitors();
    final preApproved = await _repository.getPreApproved();
    state = state.copyWith(
      visitorLog: visitors,
      preApprovedLog: preApproved,
      isLoading: false,
    );
  }

  void checkInVisitor(Visitor visitor, PreApprovedVisitor? preApproved) {
    if (preApproved != null) {
      // Remove from pre-approved list
      final updatedPreApproved = List<PreApprovedVisitor>.from(state.preApprovedLog)
        ..removeWhere((v) => v.cnic == preApproved.cnic);
      
      state = state.copyWith(
        visitorLog: [...state.visitorLog, visitor],
        preApprovedLog: updatedPreApproved,
      );
    } else {
      // Just a walk-in
      state = state.copyWith(visitorLog: [...state.visitorLog, visitor]);
    }
  }

  void checkOutVisitor(String visitorId) {
    final updatedLog = state.visitorLog.map((v) {
      if (v.id == visitorId) {
        return Visitor(
          // Create a new instance with the checkout time
          name: v.name, cnic: v.cnic, contact: v.contact, purpose: v.purpose,
          photoPath: v.photoPath, checkInTime: v.checkInTime, wasPreApproved: v.wasPreApproved,
          checkOutTime: DateTime.now(),
        );
      }
      return v;
    }).toList();
    
    state = state.copyWith(visitorLog: updatedLog);
  }
}

// 3. Create the Providers
final visitorRepositoryProvider = Provider((ref) => VisitorRepository());

final visitorProvider = StateNotifierProvider<VisitorNotifier, VisitorState>((ref) {
  final repository = ref.watch(visitorRepositoryProvider);
  return VisitorNotifier(repository);
});