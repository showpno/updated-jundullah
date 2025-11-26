import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_connect.dart';

import '../utility/constants.dart';

class HttpService {
  // Configure GetConnect with timeout settings
  GetConnect get _connect {
    final connect = GetConnect();
    connect.timeout = const Duration(seconds: 30); // 30 second timeout
    connect.allowAutoSignedCert = true;
    return connect;
  }

  Future<Response> getItems({required String endpointUrl}) async {
    try {
      log('GET: $SERVER_URL/$endpointUrl');
      return await _connect.get('$SERVER_URL/$endpointUrl');
    } catch (e) {
      log('Error: $e');
      return Response(
          body: json.encode({'error': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> addItem(
      {required String endpointUrl, required dynamic itemData}) async {
    try {
      log('POST: $SERVER_URL/$endpointUrl');
      final response =
          await _connect.post('$SERVER_URL/$endpointUrl', itemData);
      log('Response status: ${response.statusCode}, body: ${response.body}');
      return response;
    } catch (e) {
      log('Error: $e');
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> updateItem(
      {required String endpointUrl,
      required String itemId,
      required dynamic itemData}) async {
    try {
      log('PUT: $SERVER_URL/$endpointUrl/$itemId');
      return await _connect.put('$SERVER_URL/$endpointUrl/$itemId', itemData);
    } catch (e) {
      log('Error: $e');
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> deleteItem(
      {required String endpointUrl, required String itemId}) async {
    try {
      log('DELETE: $SERVER_URL/$endpointUrl/$itemId');
      return await _connect.delete('$SERVER_URL/$endpointUrl/$itemId');
    } catch (e) {
      log('Error: $e');
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }
}
