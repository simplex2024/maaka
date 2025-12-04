import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/meat_repository.dart';
import '../../data/models/meat_model.dart';
import 'meat_event.dart';
import 'meat_state.dart';

class MeatBloc extends Bloc<MeatEvent, MeatState> {
  final MeatRepository _repository;

  MeatBloc(this._repository) : super(const MeatState()) {
    on<LoadMeatCategories>(_onLoadCategories);
    on<SelectMeatCategory>(_onSelectCategory);
  }

  Future<void> _onLoadCategories(
    LoadMeatCategories event,
    Emitter<MeatState> emit,
  ) async {
    emit(state.copyWith(status: MeatStatus.loading));
    try {
      final categories = await _repository.getCategories();
      final initialCategory = categories.isNotEmpty ? categories.first.id : '';
      
      // Load products for the first category initially
      final products = initialCategory.isNotEmpty 
          ? await _repository.getProducts(initialCategory) 
          : <MeatProduct>[];

      emit(state.copyWith(
        status: MeatStatus.success,
        categories: categories,
        selectedCategoryId: initialCategory,
        products: products, // Cast if necessary, but type inference should work
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MeatStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSelectCategory(
    SelectMeatCategory event,
    Emitter<MeatState> emit,
  ) async {
    if (event.categoryId == state.selectedCategoryId) return;

    emit(state.copyWith(
      status: MeatStatus.loading,
      selectedCategoryId: event.categoryId,
    ));

    try {
      final products = await _repository.getProducts(event.categoryId);
      emit(state.copyWith(
        status: MeatStatus.success,
        products: products,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MeatStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
