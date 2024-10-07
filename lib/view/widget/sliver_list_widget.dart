import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'dart:async';


class SliverListWidget<T> extends StatefulWidget {
  final List<T> allElement;
  final Widget Function(BuildContext context, T item, int index) childBuilder;
  final bool Function(T input, String search) where;
  final String hintText;
  final String header;
  const SliverListWidget({
    super.key,
    required this.allElement,
    required this.childBuilder,
    required this.where,
    required this.hintText, required this.header,
  });

  @override
  State<SliverListWidget<T>> createState() => _SliverListWidgetState<T>();
}

class _SliverListWidgetState<T> extends State<SliverListWidget<T>> {
  static const _pageSize = 17;

  final PagingController<int, T> _pagingController = PagingController(firstPageKey: 0);
  int turn = 0;
  String? _searchTerm;

  @override
  void initState() {

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  Future<void> _fetchPage(pageKey) async {
    bool isSearch = false;
    try {
      List<T> newItems = [];
      List<T> _Items = widget.allElement;
      if (_pageSize * (turn + 1) < _Items.length) {
        if (_searchTerm == null || _searchTerm!.isEmpty) {
          newItems = _Items.sublist(_pageSize * turn, _pageSize * (turn + 1));
          isSearch = false;
        } else {
          turn = -1;
          isSearch = true;
          newItems = _Items.where((element) => widget.where(element, _searchTerm!)).toList();
        }
      } else {
        if (_searchTerm == null || _searchTerm!.isEmpty) {
          newItems = _Items.sublist(_pageSize * turn);
          isSearch = false;
        } else {
          turn = -1;
          isSearch = true;
          newItems = _Items.where((element) => widget.where(element, _searchTerm!)).toList();
        }
      }
      turn++;
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage || isSearch) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      print(error.toString());
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_searchTerm!=null) {
      _pagingController.refresh();
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                BackButton(),
                SizedBox(width: 30,),
                Text(widget.header,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    decoration:BoxDecoration(border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(15)),
                    width: 500,
                    child: SearchInputSliver(
                      hintText:widget.hintText,
                      onChanged: _updateSearchTerm,
                    ),
                  ),
                ),
                SizedBox(width: 30,),
              ],
            ),
            Expanded(
              child: CustomScrollView(
                shrinkWrap: true,
                slivers: [
                  PagedSliverList<int, T>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<T>(itemBuilder: widget.childBuilder),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateSearchTerm(String searchTerm) {
    _searchTerm = searchTerm;
    _pagingController.refresh();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

class SearchInputSliver extends StatefulWidget {
  const SearchInputSliver({
    Key? key,
    this.onChanged,
    this.debounceTime, required this.hintText,
  }) : super(key: key);
  final ValueChanged<String>? onChanged;
  final Duration? debounceTime;
  final String hintText;

  @override
  State<SearchInputSliver> createState() => _SearchInputSliverState();
}

class _SearchInputSliverState extends State<SearchInputSliver> {
  final StreamController<String> _textChangeStreamController = StreamController();
  late StreamSubscription _textChangesSubscription;

  @override
  void initState() {
    _textChangesSubscription = _textChangeStreamController.stream.distinct().listen((text) {
      final onChanged = widget.onChanged;
      if (onChanged != null) {
        onChanged(text);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: TextFormField(
      style: TextStyle(height: 1),
      textAlign: TextAlign.center,
      decoration:  InputDecoration(
        border: InputBorder.none,
        hintText: widget.hintText,
        hintStyle: TextStyle(height: 1)
      ),
      onChanged: _textChangeStreamController.add,
    ),
  );

  @override
  void dispose() {
    _textChangeStreamController.close();
    _textChangesSubscription.cancel();
    super.dispose();
  }
}
