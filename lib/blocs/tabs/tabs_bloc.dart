import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:desmosdemo/blocs/tabs/bloc.dart';
import 'package:desmosdemo/models/models.dart';

class TabsBloc extends Bloc<TabsEvent, AppTab> {
  @override
  AppTab get initialState => AppTab.posts;

  @override
  Stream<AppTab> mapEventToState(TabsEvent event) async* {
    if (event is UpdateTab) {
      yield event.tab;
    }
  }
}
