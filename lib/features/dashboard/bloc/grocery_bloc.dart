import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/shop_repository.dart';
import 'grocery_event.dart';
import 'grocery_state.dart';

class GroceryBloc extends Bloc<GroceryEvent, GroceryState> {
  GroceryBloc(this._repository) : super(const GroceryState()) {
    on<GroceryShopsLoaded>(_onShopsLoaded);
    on<GroceryFilterChanged>(_onFilterChanged);
    on<GrocerySearchChanged>(_onSearchChanged);
    on<GrocerySearchRequested>(_onSearchRequested);
  }

  final ShopRepository _repository;

  Future<void> _onShopsLoaded(
    GroceryShopsLoaded event,
    Emitter<GroceryState> emit,
  ) async {
    emit(state.copyWith(
      status: GroceryStatus.loading,
      errorMessage: null,
      filterBy: event.filterBy,
    ));

    try {
      final shops = await _repository.getNearbyShops(
        location: event.location,
        filterBy: event.filterBy,
      );
      emit(state.copyWith(
        status: GroceryStatus.success,
        shops: shops,
        filterBy: event.filterBy,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: GroceryStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  void _onFilterChanged(
    GroceryFilterChanged event,
    Emitter<GroceryState> emit,
  ) {
    if (state.filterBy != event.filterBy) {
      // Reload shops with new filter
      add(GroceryShopsLoaded(
        location: 'Nesapakkam, Chennai', // This should come from state or params
        filterBy: event.filterBy,
      ));
    }
  }

  void _onSearchChanged(
    GrocerySearchChanged event,
    Emitter<GroceryState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onSearchRequested(
    GrocerySearchRequested event,
    Emitter<GroceryState> emit,
  ) async {
    if (event.query.isEmpty) {
      // If search is empty, reload all shops
      add(const GroceryShopsLoaded(
        location: 'Nesapakkam, Chennai',
        filterBy: 'distance',
      ));
      return;
    }

    emit(state.copyWith(
      status: GroceryStatus.loading,
      errorMessage: null,
      searchQuery: event.query,
    ));

    try {
      final shops = await _repository.searchShops(event.query);
      emit(state.copyWith(
        status: GroceryStatus.success,
        shops: shops,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: GroceryStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }
}

