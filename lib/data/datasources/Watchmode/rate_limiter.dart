import 'dart:collection';
import 'package:injectable/injectable.dart';

@singleton
class RateLimiter {
  final int maxRequests;
  final Duration timeWindow;
  final Queue<DateTime> _requestTimestamps = Queue();

  RateLimiter({
    this.maxRequests = 120,
    this.timeWindow = const Duration(minutes: 1),
  });

  bool canMakeRequest() {
    final now = DateTime.now();

    // Remove timestamps outside the time window
    while (_requestTimestamps.isNotEmpty &&
        now.difference(_requestTimestamps.first) > timeWindow) {
      _requestTimestamps.removeFirst();
    }

    return _requestTimestamps.length < maxRequests;
  }

  void registerRequest() {
    _requestTimestamps.add(DateTime.now());
  }

  Duration timeUntilNextAvailable() {
    if (canMakeRequest()) return Duration.zero;

    final oldestTimestamp = _requestTimestamps.first;
    final timeToWait = timeWindow - DateTime.now().difference(oldestTimestamp);
    return timeToWait.isNegative ? Duration.zero : timeToWait;
  }
}