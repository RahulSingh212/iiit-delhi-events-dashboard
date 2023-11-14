import 'package:flutter_test/flutter_test.dart';
import 'package:iiitd_evnts/providers/NavBarIndexProvider.dart';

void main() {
  test('setPageIndex should update pageIndex', () {
    final navBarIndexProvider = NavBarIndexProvider();

    expect(navBarIndexProvider.pageIndex, 0); // Initial value

    navBarIndexProvider.setPageIndex(1);

    expect(navBarIndexProvider.pageIndex, 1); // After calling setPageIndex(1)

  });
}
