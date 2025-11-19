abstract class GroceryEvent {
  const GroceryEvent();
}

class GroceryShopsLoaded extends GroceryEvent {
  const GroceryShopsLoaded({
    required this.location,
    this.filterBy = 'distance',
  });

  final String location;
  final String filterBy; // 'distance' or 'rating'
}

class GroceryFilterChanged extends GroceryEvent {
  const GroceryFilterChanged(this.filterBy);

  final String filterBy; // 'distance' or 'rating'
}

class GrocerySearchChanged extends GroceryEvent {
  const GrocerySearchChanged(this.query);

  final String query;
}

class GrocerySearchRequested extends GroceryEvent {
  const GrocerySearchRequested(this.query);

  final String query;
}

