import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:desmosdemo/entities/entities.dart';

import '../export.dart';

class TabsBloc extends Bloc<TabsEvent, AppTab> {
  TabsBloc();

  factory TabsBloc.create() {
    return TabsBloc();
  }

  @override
  AppTab get initialState => AppTab.posts;

  @override
  Stream<AppTab> mapEventToState(TabsEvent event) async* {
    if (event is UpdateTab) {
      yield event.tab;
    }
  }
}
