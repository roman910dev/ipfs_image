library ipfs_image;

import 'package:flutter/widgets.dart';

// ignore: camel_case_extensions
extension ImageIPFS on Image {
  static Image ipfs(String src, {
    BoxFit? fit,
  }) {
    final Uri uri = Uri.parse(src);
    final String cid = uri.host;
    final String path = uri.path;

    final List<String> providers = [
      'https://$cid.ipfs.nftstorage.link$path',
      'https://$cid.ipfs.dweb.link$path',
      'https://$cid.ipfs.cf-ipfs.com$path',
      'https://ipfs.io/ipfs/$cid$path',
    ];

    Image fromProvider(int index) {
      return Image.network(
        providers[index],
        errorBuilder: index < providers.length - 1
            ? (_, __, ___) => fromProvider(index+1)
            : null,
        fit: fit,
      );
    }

    if (uri.scheme != 'ipfs') {
      return Image.network(src, fit: fit,);
    } else {
      return fromProvider(0);
    }
  }
}

extension NetworkImageIPFS on ImageProvider {
  bool isIPFS() => this is NetworkImage &&
      Uri.tryParse((this as NetworkImage).url)?.scheme == 'ipfs';
}
