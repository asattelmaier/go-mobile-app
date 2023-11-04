class HttpHeadersBuilder {
  final Map<String, String> _headers;

  HttpHeadersBuilder._(this._headers);

  factory HttpHeadersBuilder.token(String token) =>
      HttpHeadersBuilder._({"Authorization": "Bearer $token"});

  Map<String, String> build() => _headers;
}
