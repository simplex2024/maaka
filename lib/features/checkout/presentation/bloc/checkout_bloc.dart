import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/models/order_model.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final OrderRepository _repository;

  CheckoutBloc(this._repository) : super(const CheckoutState()) {
    on<LoadCart>(_onLoadCart);
    on<UpdateCartItem>(_onUpdateCartItem);
    on<RemoveCartItem>(_onRemoveCartItem);
    on<SelectSchedule>(_onSelectSchedule);
    on<PlaceOrder>(_onPlaceOrder);
  }

  void _onLoadCart(LoadCart event, Emitter<CheckoutState> emit) {
    emit(state.copyWith(
      items: event.items,
      shopId: event.shopId,
      shopName: event.shopName,
      status: CheckoutStatus.initial,
    ));
  }

  void _onUpdateCartItem(UpdateCartItem event, Emitter<CheckoutState> emit) {
    final updatedItems = state.items.map((item) {
      return item.id == event.item.id ? event.item : item;
    }).toList();
    emit(state.copyWith(items: updatedItems));
  }

  void _onRemoveCartItem(RemoveCartItem event, Emitter<CheckoutState> emit) {
    final updatedItems = state.items.where((item) => item.id != event.itemId).toList();
    emit(state.copyWith(items: updatedItems));
  }

  void _onSelectSchedule(SelectSchedule event, Emitter<CheckoutState> emit) {
    emit(state.copyWith(schedule: event.schedule));
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<CheckoutState> emit) async {
    if (state.schedule == null) {
      emit(state.copyWith(
        status: CheckoutStatus.failure,
        errorMessage: 'Please select a delivery schedule',
      ));
      return;
    }

    emit(state.copyWith(status: CheckoutStatus.loading));

    try {
      final order = Order(
        id: '', // Will be assigned by service
        shopId: state.shopId,
        shopName: state.shopName,
        items: state.items,
        totalAmount: state.totalAmount,
        status: OrderStatus.placed,
        schedule: state.schedule,
        createdAt: DateTime.now(),
      );

      final placedOrder = await _repository.placeOrder(order);
      
      emit(state.copyWith(
        status: CheckoutStatus.success,
        placedOrder: placedOrder,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CheckoutStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
