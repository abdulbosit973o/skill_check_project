part of 'recitation_bloc.dart';

@immutable
sealed class RecitationEvent {}

class AddRecitationEvent extends RecitationEvent {
  final String filePath;

  AddRecitationEvent({required this.filePath});
}
