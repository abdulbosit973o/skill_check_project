import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skill_check_project/core/consts/app_res.dart';
import 'package:skill_check_project/features/main/data/models/recitation_model.dart';

part 'recitation_event.dart';

part 'recitation_state.dart';

class RecitationBloc extends Bloc<RecitationEvent, RecitationState> {
  final repo = storageRepository;

  RecitationBloc() : super(RecitationInitial()) {
    on<AddRecitationEvent>((event, emit) async {
      emit(RecitationLoading());
      final response = await repo.addRecitation(RecitationModel(
          filePath: event.filePath,
          addedTime: DateTime.now().toIso8601String()));
      emit(response
          ? RecitationSuccess()
          : RecitationError(
              "Ovozni qo'shishda xatolik ! Iltimos qayta urinib ko'ring"));
    });
  }
}
