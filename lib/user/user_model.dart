import 'package:go_app/user/input/user_dto.dart';

class UserModel {
  final String _id;
  final String _username;

  const UserModel(this._id, this._username);

  factory UserModel.fromDto(UserDto dto) => UserModel(dto.id, dto.username);

  UserDto toDto() => UserDto(_id, _username);

  const UserModel.empty()
      : this._id = "",
        this._username = "";

  bool get isEmpty => _id.isEmpty;

  bool get isPresent => !isEmpty;

  String get id => _id;
}
