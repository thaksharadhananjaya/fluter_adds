part of 'adds_bloc.dart';

@immutable
abstract class AddsState {}

class AddsInitial extends AddsState {}

class LoadedAdds extends AddsState{
  final List<Adds> addsList;
  LoadedAdds({this.addsList});
  List<Object> get props => [this.addsList];
}


class AddsErrorState extends AddsState{
  final String message;
  AddsErrorState({this.message});
  List<Object> get props => [this.message];
}
