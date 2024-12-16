part of 'recitation_bloc.dart';

@immutable
sealed class RecitationState {}

final class RecitationInitial extends RecitationState {}
final class RecitationLoading extends RecitationState {}
final class RecitationSuccess extends RecitationState {}
final class RecitationError extends RecitationState {
  final String errorText;

  RecitationError(this.errorText);
}
