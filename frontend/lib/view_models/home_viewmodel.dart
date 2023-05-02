import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:uscheduler/repositories/events_repository.dart';
import '../utils/status.dart';

@singleton
class HomeViewModel extends ChangeNotifier {
  final EventsRepository _eventsRepository;

  HomeViewModel(this._eventsRepository);

  Future<Status> getClubsAndClasses(String query) async {
    return _eventsRepository.getClubsAndClasses(query);
  }
}


