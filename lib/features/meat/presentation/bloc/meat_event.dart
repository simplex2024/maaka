import 'package:equatable/equatable.dart';

abstract class MeatEvent extends Equatable {
  const MeatEvent();

  @override
  List<Object> get props => [];
}

class LoadMeatCategories extends MeatEvent {}

class SelectMeatCategory extends MeatEvent {
  final String categoryId;

  const SelectMeatCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
