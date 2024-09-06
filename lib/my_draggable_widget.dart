import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class MyDraggableWidget extends StatelessWidget {
  const MyDraggableWidget({
    super.key,
    required this.data,
    required this.child,
    required this.onDragStart,
  });

  final String data;
  final Widget child;
  final Function() onDragStart;

  @override
  Widget build(BuildContext context) {
    return DragItemWidget(
      dragItemProvider: (DragItemRequest request) {
        onDragStart();
        final item = DragItem(
          localData: data,
        );

        return item;
      },
      allowedOperations: () => [DropOperation.copy],
      dragBuilder: (context, child) {
        return Opacity(
          opacity: 0.8,
          child: child,
        );
      },
      child: DraggableWidget(child: child),
    );
  }
}
