### ViewState

提供 ViewState，主要用于维护 View 所需的数据，需要配合 riverpod 进行使用。

```dart
class Book {
  String name = "";
  String author = "";
}

final bookProvider = StateNotifierProvider<BookViewModel, ViewState<Book>>((ref) {
  return BookViewModel();
});

// 继承自 ViewModel
class BookViewModel extends ViewModel<Book> {

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