import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skill_check_project/core/consts/app_res.dart';
import 'package:skill_check_project/features/main/data/models/recitation_model.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final repo = storageRepository;

  ChatBloc() : super(ChatInitial()) {
    on<GetAllRecitationsEvent>((event, emit) async {
      emit(ChatLoading());
      final recitations = await repo.getAllRecitations();
      emit(ChatGetRecitationsSuccess(recitationList: recitations));
    });
  }
}
