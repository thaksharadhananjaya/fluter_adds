
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/models/model.dart';
import 'package:test/respositories/adds_respo.dart';

part 'addsevent.dart';
part 'adds_state.dart';

class AddsBloc extends Bloc<AddsEvent, AddsState> {

  AddsBloc()
      : super(AddsInitial());
  List<Adds> addsList = [];
  AddsRepo addsRepo = AddsRepo();
  int page = -5;
  bool isLoading = false;
  @override
  Stream<AddsState> mapEventToState(AddsEvent event) async* {
    if (event is FetchAdds) {
      if (!isLoading) {
        isLoading = true;
        page += 5;
        List<Adds> list =
            await addsRepo.getAdds(page);
        try {
          if (list == null) {
            if (addsList.length > 0) {
              page -= 5;
              yield LoadedAdds(addsList: addsList);
            } else {
              AddsErrorState(message: "Not found adds");
            }
          } else {
            addsList.addAll(list);
            yield LoadedAdds(addsList: addsList);
          }
        } catch (e) {
          page -= 5;
          yield AddsErrorState(message: "Error !");
        }
        isLoading = false;
      }
    } else if (event is ReloadAdds) {
      yield null;
      addsList.clear();
      List<Adds> list =
          await addsRepo.getAdds(page);
      try {
        if (list == null) {
          yield AddsErrorState(message: "Empty");
        } else {
          addsList.addAll(list);
          yield LoadedAdds(addsList: addsList);
        }
      } catch (e) {
        yield AddsErrorState(message: "Error !");
      }
    }
  }
}
