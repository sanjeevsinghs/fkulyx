//
// import 'dart:developer' as dev;
// import '../core/custom_imports.dart';
//
//
//
// class LoggingInterceptor implements InterceptorContract {
//
//   @override
//   FutureOr<bool> shouldInterceptRequest() {
//     return true;
//   }
//
//   @override
//   FutureOr<bool> shouldInterceptResponse() {
//     return true;
//   }
//
//   @override
//   FutureOr<BaseRequest> interceptRequest({required BaseRequest request}) {
//     if (kDebugMode) {
//       print('----- Request -----');
//       print(request.toString());
//       print(request.headers.toString());
//
//       if (request is Request) {
//        // print('Body: ${request.body}');
//         dev.log('Body: ${request.body}');
//       } else {
//         print('Body: (Not accessible for ${request.runtimeType})');
//       }
//     }
//     return request;
//   }
//
//   @override
//   FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) {
//     if (kDebugMode){
//       dev.log('----- Response -----');
//       dev.log('Code: ${response.statusCode}');
//       if (response is Response) {
//         dev.log(utf8.decode((response).bodyBytes));
//       }
//
//     }
//
//     switch (response.statusCode) {
//       case 401:
//         // _handleUnauthorized();
//         break;
//       case 500:
//         showToast('Service Error');
//         break;
//       case 502:
//         showToast('Bad Gateway');
//         break;
//     }
//     return response;
//   }
//
//   void _handleUnauthorized() {
//     showToast("Your session has expired, please login again.");
//     // Clear session data
//     access_token = "";
//     PreferenceManager.clearSharedPref();
//     AppDelegate().reset();
//
//     final context = NavigationService.navigatorKey.currentContext;
//     if (context != null) {
//       // Navigator.pushAndRemoveUntil(
//       //   context,
//       //   MaterialPageRoute(builder: (_) => const Splash()),
//       //       (route) => false,
//       // );
//     }
//   }
// }
//
