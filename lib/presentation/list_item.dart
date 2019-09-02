abstract class ListItem<T> {}

class HeadingItem extends ListItem {
  final String title;

  HeadingItem(this.title);
}

class ActualItem<T> extends ListItem<T> {
  final T item;

  ActualItem(this.item);
}
