import 'package:afro_grids/blocs/chat/chat_event.dart';
import 'package:afro_grids/blocs/chat/chat_state.dart';
import 'package:afro_grids/repositories/chat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState>{
  ChatBloc(): super(ChatInitialState()){
    on<FetchNextChatsEvent>(_onFetchNextChatsEvent);
  }

  void _onFetchNextChatsEvent(FetchNextChatsEvent event, Emitter<ChatState> emit)async{
    emit(ChatLoadingState());
    try{
      var chats = await ChatRepo()
          .fetchChats(
          fromId: event.fromUser.id,
          toId: event.toUser.id,
        cursor: event.cursor,
        limit: 25
      );

    }catch(e){
      emit(ChatErrorState(e.toString()));
    }
  }
}