part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class GetAllRecitationsEvent extends ChatEvent {}
