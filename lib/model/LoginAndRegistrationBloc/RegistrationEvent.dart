part of 'RegistrationBloc.dart';


// ignore: camel_case_types
abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();
}

class UserNameChanged extends RegistrationEvent {
  final String userName;
  UserNameChanged(this.userName);
  @override
  List<Object> get props => [userName];
}

class UserNickNameChanged extends RegistrationEvent {
  final String userNickName;
  UserNickNameChanged(this.userNickName);
  @override
  List<Object> get props => [userNickName];
}


class UserIDChanged extends RegistrationEvent {
  final String userID;
  UserIDChanged(this.userID);
  @override
  List<Object> get props => [userID];
}

class PasswordChanged extends RegistrationEvent{
  final String password;
  PasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class ConfirmPasswordChanged extends RegistrationEvent{
  final String confirmPassword;
  ConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object> get props => [confirmPassword];
}

class PageChanged extends RegistrationEvent{
  final String pageState;
  PageChanged(this.pageState);

  @override
  List<Object> get props => [pageState];
}
