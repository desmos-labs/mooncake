import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:mooncake/repositories/repositories.dart';

import 'models/export.dart';

/// Implementation of [RemoteMediasSource].
class RemoteMediasSourceImpl extends RemoteMediasSource {
  final String _ipfsEndpoint;

  RemoteMediasSourceImpl({
    @required String ipfsEndpoint,
  })  : assert(ipfsEndpoint != null && ipfsEndpoint.isNotEmpty),
        _ipfsEndpoint = ipfsEndpoint;

  @override
  Future<String> uploadMedia(File file) async {
    final url = 'https://put.$_ipfsEndpoint/api/v0/add';
    final multiPartFile =
        await http.MultipartFile.fromPath('file', file.absolute.path);
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(multiPartFile);

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception(
        'Invalid IPFS answer. Expected 200, got ${response.statusCode}',
      );
    }

    final body = await response.stream.bytesToString();
    final uploadResponse = IpfsUploadResponse.fromJson(
      jsonDecode(body) as Map<String, dynamic>,
    );
    return 'https://$_ipfsEndpoint/ipfs/${uploadResponse.hash}';
  }
}
