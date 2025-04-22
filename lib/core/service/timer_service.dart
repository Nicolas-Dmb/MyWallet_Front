abstract class TimerService {
  Future<void> sleep(Duration duration);
}

class DefaultTimerService implements TimerService {
  @override
  Future<void> sleep(Duration duration) async {
    await Future.delayed(duration);
  }
}
