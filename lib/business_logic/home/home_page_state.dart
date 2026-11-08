part of 'home_page_cubit.dart';

sealed class HomePageState {}

final class HomePageInitial extends HomePageState {}

final class HomePageLoading extends HomePageState {}

final class HomePageSuccess extends HomePageState {
  final HomePageModel homePageModel;

  HomePageSuccess(this.homePageModel);
}

final class HomePageError extends HomePageState {
  final String message;

  HomePageError(this.message);
}