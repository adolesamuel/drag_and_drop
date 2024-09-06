import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:drag_and_drop/my_draggable_widget.dart';
import 'package:drag_and_drop/types.dart';
import 'package:flutter/material.dart';

class ItemPanel extends StatelessWidget {
  const ItemPanel({
    super.key,
    required this.crossAxisCount,
    required this.items,
    required this.spacing,
    required this.onDragStart,
    required this.panel,
    required this.dropPreview,
    required this.hoveringData,
    this.dragStart,
  });

  final int crossAxisCount;
  final List<String> items;
  final double spacing;
  final Function(PanelLocation) onDragStart;
  final Panel panel;
  final PanelLocation? dragStart;
  final PanelLocation? dropPreview;
  final String? hoveringData;

  @override
  Widget build(BuildContext context) {
    final itemsCopy = List<String>.from(items);
    PanelLocation? dragStartCopy;
    PanelLocation? dropPreviewCopy;
    if (dragStart != null) {
      dragStartCopy = dragStart?.copyWith();
    }
    if (dropPreview != null && hoveringData != null) {
      dropPreviewCopy = dropPreview!.copyWith(
        index: min(items.length, dropPreview!.$1),
      );

      if (dragStartCopy?.$2 == dropPreviewCopy.$2) {
        itemsCopy.removeAt(dragStartCopy!.$1);
        dragStartCopy = null;
      }
      itemsCopy.insert(
        min(dropPreview!.$1, itemsCopy.length),
        hoveringData!,
      );
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      padding: const EdgeInsets.all(4),
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      children:
          items.asMap().entries.map<Widget>((MapEntry<int, String> entry) {
        Widget child;
        Color textColor =
            entry.key == dragStartCopy?.$1 || entry.key == dropPreviewCopy?.$1
                ? Colors.grey
                : Colors.white;
        final content = Center(
          child: Text(
            entry.value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              color: textColor,
            ),
          ),
        );

        if (entry.key == dragStartCopy?.$1) {
          child = Container(
            height: 200,
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8)),
            child: content,
          );
        } else if (entry.key == dropPreviewCopy?.$1) {
          child = DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(20),
            dashPattern: const [10, 10],
            color: Colors.grey,
            strokeWidth: 2,
            child: content,
          );
        } else {
          child = Container(
            height: 200,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(8)),
            child: content,
          );
        }

        return Draggable(
          feedback: child,
          child: MyDraggableWidget(
              data: entry.value,
              onDragStart: () => onDragStart((entry.key, panel)),
              child: child),
        );
      }).toList(),
    );
  }
}
