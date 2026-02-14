import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Base API client for all HTTP requests
/// Handles authentication headers, error handling, retry logic, and common HTTP operations
class ApiClient {
  // TODO: Replace with your actual API URL
  static const String baseUrl = 'https://api.yourapp.com';
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  /// Get authorization headers with token
  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: _tokenKey);
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Retry logic wrapper
  Future<T> _withRetry<T>(
    Future<T> Function() operation, {
    bool shouldRetry = true,
  }) async {
    int attempts = 0;
    Exception? lastException;

    while (attempts < maxRetries) {
      try {
        return await operation();
      } on ApiException catch (e) {
        // Don't retry client errors (4xx) except 429 (rate limit)
        if (e.statusCode != null &&
            e.statusCode! >= 400 &&
            e.statusCode! < 500 &&
            e.statusCode! != 429) {
          rethrow;
        }
        lastException = e;
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
      }

      attempts++;
      if (attempts < maxRetries && shouldRetry) {
        await Future.delayed(retryDelay * attempts);
      }
    }

    throw lastException ??
        ApiException('Request failed after $maxRetries attempts');
  }

  /// Handle API response and throw appropriate errors
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw ApiException('Unauthorized. Please login again.', 401);
    } else if (response.statusCode == 404) {
      throw ApiException('Resource not found', 404);
    } else if (response.statusCode >= 500) {
      throw ApiException(
        'Server error. Please try again later.',
        response.statusCode,
      );
    } else {
      final errorMessage = _extractErrorMessage(response.body);
      throw ApiException(errorMessage, response.statusCode);
    }
  }

  /// Extract error message from response body
  String _extractErrorMessage(String body) {
    try {
      final json = jsonDecode(body);
      return json['message'] ?? json['error'] ?? 'Request failed';
    } catch (_) {
      return 'Request failed';
    }
  }

  /// GET request with retry logic
  Future<dynamic> get(String endpoint, {bool retry = true}) async {
    return _withRetry(() async {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      return _handleResponse(response);
    }, shouldRetry: retry);
  }

  /// POST request with retry logic
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool retry = true,
  }) async {
    return _withRetry(() async {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: body != null ? json.encode(body) : null,
      );
      return _handleResponse(response);
    }, shouldRetry: retry);
  }

  /// PUT request with retry logic
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool retry = true,
  }) async {
    return _withRetry(() async {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: body != null ? json.encode(body) : null,
      );
      return _handleResponse(response);
    }, shouldRetry: retry);
  }

  /// PATCH request with retry logic
  Future<dynamic> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool retry = true,
  }) async {
    return _withRetry(() async {
      final headers = await _getHeaders();
      final response = await http.patch(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: body != null ? json.encode(body) : null,
      );
      return _handleResponse(response);
    }, shouldRetry: retry);
  }

  /// DELETE request with retry logic
  Future<dynamic> delete(String endpoint, {bool retry = true}) async {
    return _withRetry(() async {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      return _handleResponse(response);
    }, shouldRetry: retry);
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}
