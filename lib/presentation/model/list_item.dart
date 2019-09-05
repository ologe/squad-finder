abstract class ListItem<T> {}

class HeadingItem<T> extends ListItem<T> {
  final String title;

  HeadingItem(this.title);
}

class ActualItem<T> extends ListItem<T> {
  final T item;

  ActualItem(this.item);
}
