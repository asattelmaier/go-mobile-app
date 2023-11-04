import 'package:go_app/user/input/tokens_dto.dart';

class TokensModel {
  final String _refreshToken;
  final String _accessToken;

  const TokensModel(this._refreshToken, this._accessToken);

  factory TokensModel.fromDto(TokensDto dto) =>
      TokensModel(dto.refreshToken, dto.accessToken);

  TokensDto toDto() => TokensDto(_refreshToken, _accessToken);

  const TokensModel.empty()
      : this._refreshToken = "",
        this._accessToken = "";

  bool get isEmpty => _refreshToken.isEmpty;

  bool get isPresent => !isEmpty;

  String get accessToken => _accessToken;

  String get refreshToken => _refreshToken;
}
