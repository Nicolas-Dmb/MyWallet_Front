import 'package:get_it/get_it.dart';
import 'package:mywallet_mobile/features/trading/domain/trading_quizz_service.dart';

final GetIt locator = GetIt.instance;

void setupTradingLocator() {
  locator.registerFactory<TradingQuizzService>(() => TradingQuizzService());
}
