import 'package:equatable/equatable.dart';
import '../../../data/models/shop_models.dart';

enum GroceryStatus { initial, loading, success, failure }

class GroceryState extends Equatable {
  const GroceryState({
    this.shops = const [],
    this.status = GroceryStatus.initial,
    this.errorMessage,
    this.filterBy = 'distance',
    this.searchQuery = '',
  });

  final List<ShopData> shops;
  final GroceryStatus status;
  final String? errorMessage;
  final String filterBy;
  final String searchQuery;

  bool get isLoading => status == GroceryStatus.loading;
  bool get isSuccess => status == GroceryStatus.success;
  bool get isFailure => status == GroceryStatus.failure;

  GroceryState copyWith({
    List<ShopData>? shops,
    GroceryStatus? status,
    String? errorMessage,
    String? filterBy,
    String? searchQuery,
  }) {
    return GroceryState(
      shops: shops ?? this.shops,
      status: status ?? this.status,
      errorMessage: errorMessage,
      filterBy: filterBy ?? this.filterBy,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [shops, status, errorMessage, filterBy, searchQuery];
}

