part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatSuccess extends ChatState {
  final String message;

  ChatSuccess({required this.message});
}

final class ChatGetRecitationsSuccess extends ChatState {
  final List<RecitationModel> recitationList;

  ChatGetRecitationsSuccess({required this.recitationList});
}

final class ChatError extends ChatState {
  final String errorText;

  ChatError(this.errorText);
}
