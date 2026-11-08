import 'package:academichub/data/model/home/home_page_model.dart';
import 'package:academichub/data/repository/home/home_page_repository.dart';
import 'package:bloc/bloc.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  final HomePageRepository _homePageRepository;

  HomePageCubit(this._homePageRepository) : super(HomePageInitial());

  Future<void> fetchDashboardData(String userId) async {
    emit(HomePageLoading());

    try {
      final homeData =
          await _homePageRepository.fetchDashboardData(userId);

      emit(HomePageSuccess(homeData));
    } catch (e) {
      emit(HomePageError(e.toString()));
    }
  }
}