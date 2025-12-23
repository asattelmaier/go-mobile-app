import 'package:session_server_client/api.dart';

class TokensModel {
  final String _refreshToken;
  final String _accessToken;

  const TokensModel(this._refreshToken, this._accessToken);

  // TODO: Define mandatory fields in the client definition. Currently many fields are nullable in the generated DTOs.
  factory TokensModel.fromDto(TokensDto dto) =>
      TokensModel(dto.refreshToken ?? "", dto.accessToken ?? "");

  TokensDto toDto() => TokensDto(refreshToken: _refreshToken, accessToken: _accessToken);

  const TokensModel.empty()
      : this._refreshToken = "",
        this._accessToken = "";

  bool get isEmpty => _refreshToken.isEmpty;

  bool get isPresent => !isEmpty;

  String get accessToken => _accessToken;

  String get refreshToken => _refreshToken;
}
