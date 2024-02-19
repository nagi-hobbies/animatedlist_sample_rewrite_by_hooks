import 'package:animatedlist_sample_rewrite_by_hooks/card_item.dart';
import 'package:animatedlist_sample_rewrite_by_hooks/list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AnimatedListHook extends HookWidget {
  const AnimatedListHook({super.key});

  @override
  Widget build(BuildContext context) {
    final _listKey = useMemoized(() => GlobalKey<AnimatedListState>(), []);

    Widget _buildRemovedItem(
        int item, BuildContext context, Animation<double> animation) {
      return CardItem(
        animation: animation,
        item: item,
      );
    }

    final _list = useState<ListModel<int>>(ListModel<int>(
      listKey: _listKey,
      initialItems: <int>[0, 1, 2],
      removedItemBuilder: _buildRemovedItem,
    ));
    final _selectedItem = useState<int?>(null);
    final _nextItem = useState<int>(3);

    void _insert() {
      final int index = _selectedItem.value == null
          ? _list.value.length
          : _list.value.indexOf(_selectedItem.value!);
      _list.value.insert(index, _nextItem.value++);
    }

    void _remove() {
      if (_selectedItem.value != null) {
        _list.value.removeAt(_list.value.indexOf(_selectedItem.value!));
        _selectedItem.value = null;
      }
    }

    Widget _buildItem(
        BuildContext context, int index, Animation<double> animation) {
      return CardItem(
        animation: animation,
        item: _list.value[index],
        selected: _selectedItem == _list.value[index],
        onTap: () {
          _selectedItem.value = _selectedItem.value == _list.value[index]
              ? null
              : _list.value[index];
        },
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AnimatedList'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: _insert,
              tooltip: 'insert a new item',
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle),
              onPressed: _remove,
              tooltip: 'remove the selected item',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _list.value.length,
            itemBuilder: _buildItem,
          ),
        ),
      ),
    );
  }
}
