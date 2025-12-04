import 'package:equatable/equatable.dart';
import '../../data/models/meat_model.dart';

enum MeatStatus { initial, loading, success, failure }

class MeatState extends Equatable {
  final MeatStatus status;
  final List<MeatCategory> categories;
  final List<MeatProduct> products;
  final String selectedCategoryId;
  final String? errorMessage;

  const MeatState({
    this.status = MeatStatus.initial,
    this.categories = const [],
    this.products = const [],
    this.selectedCategoryId = '',
    this.errorMessage,
  });

  MeatState copyWith({
    MeatStatus? status,
    List<MeatCategory>? categories,
    List<MeatProduct>? products,
    String? selectedCategoryId,
    String? errorMessage,
  }) {
    return MeatState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, categories, products, selectedCategoryId, errorMessage];
}
