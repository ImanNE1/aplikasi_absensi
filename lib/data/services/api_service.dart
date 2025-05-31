import 'package:dio/dio.dart';
import '/core/constants/app_constants.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Untuk mengambil token

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl)) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // (Opsional) Ambil token dari SharedPreferences dan tambahkan ke header
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // String? token = prefs.getString(AppConstants.tokenKey);
          // if (token != null) {
          //   options.headers['Authorization'] = 'Bearer $token';
          // }
          return handler.next(options); // Lanjutkan request
        },
        onError: (DioException e, handler) {
          // Tangani error global di sini jika perlu
          print('API Error: ${e.message}');
          if (e.response?.statusCode == 401) {
            // Handle unauthorized, mungkin redirect ke login
            print('Unauthorized access - Token might be expired');
          }
          return handler.next(e); // Lanjutkan error
        },
      ),
    );
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      // Tangani error spesifik untuk request ini atau lempar kembali
      throw _handleError(e);
    }
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Tambahkan method lain seperti put, delete jika diperlukan

  String _handleError(DioException error) {
    String errorDescription = "";
    if (error.response != null) {
      // Error dari server (status code bukan 2xx)
      print(
          "Error from server: ${error.response?.statusCode} - ${error.response?.data}");
      errorDescription =
          error.response?.data['message'] ?? "Terjadi kesalahan pada server.";
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      errorDescription = "Koneksi timeout. Periksa koneksi internet Anda.";
    } else if (error.type == DioExceptionType.cancel) {
      errorDescription = "Request dibatalkan.";
    } else if (error.type == DioExceptionType.unknown) {
      errorDescription =
          "Koneksi internet tidak tersedia atau server tidak dapat dijangkau.";
    } else {
      errorDescription = "Terjadi kesalahan tidak diketahui.";
    }
    return errorDescription;
  }
}
