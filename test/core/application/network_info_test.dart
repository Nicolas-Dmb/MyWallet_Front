import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mywallet_mobile/core/application/newtwork_info.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  late NetworkInfoImpl netWorkInfo;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    netWorkInfo = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group('isConnected', () {
    test(
      'Should forward the call to InternetConnectionChecker.hasConnection',
      () async {
        final tHasConnectionFuture = Future.value(true);

        when(
          mockInternetConnectionChecker.hasConnection,
        ).thenAnswer((_) => tHasConnectionFuture);
        final result = netWorkInfo.isConnected;
        verify(mockInternetConnectionChecker.hasConnection);
        expect(result, tHasConnectionFuture);
      },
    );
  });
}
