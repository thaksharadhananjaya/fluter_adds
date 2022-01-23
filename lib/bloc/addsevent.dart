part of 'adds_bloc.dart';

@immutable
abstract class AddsEvent {}

class FetchAdds extends AddsEvent{
  FetchAdds();
}

class ReloadAdds extends AddsEvent{
  ReloadAdds();
}
