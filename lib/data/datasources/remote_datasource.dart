import 'package:dio/dio.dart';
import '/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IRemoteDatasource {
  Future<Response> post(String path, {dynamic data});
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters});
}

class RemoteDatasource implements IRemoteDatasource {
  final Dio _dio;

  RemoteDatasource() : _dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl)) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? token = prefs.getString(AppConstants.tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            options.headers['Accept'] = 'application/json';
          }
          print("Requesting to: ${options.baseUrl}${options.path}");
          print("Headers: ${options.headers}");
          print("Data: ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(
              "Response from: ${response.requestOptions.baseUrl}${response.requestOptions.path}");
          print("Response status: ${response.statusCode}");
          print("Response data: ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('API Error Path: ${e.requestOptions.path}');
          print('API Error Message: ${e.message}');
          if (e.response != null) {
            print('API Error Response Data: ${e.response?.data}');
            print('API Error Response Status: ${e.response?.statusCode}');
            if (e.response?.statusCode == 401) {
              print('Unauthorized access - Token might be expired or invalid');
              // TODO: Handle global logout or token refresh
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  @override
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    String errorDescription = "Terjadi kesalahan. Silakan coba lagi.";
    if (error.response != null) {
      print(
          "Error from server: ${error.response?.statusCode} - ${error.response?.data}");
      if (error.response?.data is Map &&
          error.response?.data['message'] != null) {
        errorDescription = error.response?.data['message'];
      } else if (error.response?.statusCode == 401) {
        errorDescription = "Sesi Anda telah berakhir. Silakan login kembali.";
      } else if (error.response?.statusCode == 403) {
        errorDescription = "Anda tidak memiliki izin untuk mengakses ini.";
      } else if (error.response?.statusCode == 404) {
        errorDescription = "Sumber daya tidak ditemukan.";
      } else if (error.response?.statusCode == 500) {
        errorDescription =
            "Terjadi masalah pada server. Silakan coba beberapa saat lagi.";
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      errorDescription = "Koneksi timeout. Periksa koneksi internet Anda.";
    } else if (error.type == DioExceptionType.cancel) {
      errorDescription = "Request dibatalkan.";
    } else if (error.type == DioExceptionType.unknown) {
      errorDescription =
          "Koneksi internet tidak tersedia atau server tidak dapat dijangkau.";
    }
    return errorDescription;
  }
}
