### ViewModel

用于配合 riverpod 维护 View 所需的数据及状态。

```dart
class Book {
  String name = "";
  String author = "";
}

final bookProvider = StateNotifierProvider<BookViewModel, KIViewModelState<Book>>((ref) {
  return BookViewModel();
});

// 继承自 KIViewModel
class BookViewModel extends KIViewModel<Book> {

  BookViewModel() : super(null);

  Future<void> fetch() async {
    // 修改为加载状态
    load();

    // 延迟两秒响应
    await Future.delayed(const Duration(seconds: 2));

    //  加载数据完成
    finish("new data");
  }
}
```