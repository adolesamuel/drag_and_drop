import 'dart:math';

import 'package:drag_and_drop/item_panel.dart';
import 'package:drag_and_drop/my_drop_region.dart';
import 'package:drag_and_drop/types.dart';
import 'package:flutter/material.dart';

class SplitPanels extends StatefulWidget {
  const SplitPanels({
    super.key,
    this.columns = 5,
    this.itemSpacing = 4.0,
  });

  final int columns;
  final double itemSpacing;

  @override
  State<SplitPanels> createState() => _SplitPanelsState();
}

class _SplitPanelsState extends State<SplitPanels> {
  final List<String> upper = [];
  final List<String> lower = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'];

  PanelLocation? dragStart;
  PanelLocation? dropPreview;

  String? hoveringData;

  void onDragStart(PanelLocation start) {
    final data = switch (start.$2) {
      Panel.lower => lower[start.$1],
      Panel.upper => upper[start.$1],
    };
    setState(() {
      dragStart = start;
      hoveringData = data;
    });
  }

  void setExternalData(String data) => hoveringData = data;

  void updateDropPreview(PanelLocation update) => setState(() {
        dropPreview = update;
      });

  void drop() {
    assert(dropPreview != null, "Can only drop over a known location");
    assert(hoveringData != null, "can only drop when data is being dragged");

    setState(() {
      if (dragStart != null) {
        if (dragStart?.$2 == Panel.upper) {
          upper.removeAt(dragStart!.$1);
        } else {
          lower.removeAt(dragStart!.$1);
        }
      }
      if (dropPreview!.$2 == Panel.upper) {
        upper.insert(min(dropPreview!.$1, upper.length), hoveringData!);
      } else {
        lower.insert(min(dropPreview!.$1, lower.length), hoveringData!);
      }
      dragStart = null;
      dropPreview = null;
      hoveringData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final gutters = widget.columns + 1;
      final spaceForColumns =
          constraints.maxWidth - (widget.itemSpacing * gutters);

      final columnWidth = spaceForColumns / widget.columns;
      final itemSize = Size(columnWidth, columnWidth);

      return Stack(
        children: [
          Positioned(
            height: constraints.maxHeight / 2,
            width: constraints.maxWidth,
            top: 0,
            child: MyDropRegion(
              onDrop: drop,
              updateDropPreview: updateDropPreview,
              columns: widget.columns,
              childSize: itemSize,
              setExternalData: setExternalData,
              panel: Panel.upper,
              child: ItemPanel(
                crossAxisCount: widget.columns,
                spacing: widget.itemSpacing,
                items: upper,
                panel: Panel.upper,
                dropPreview:
                    dropPreview?.$2 == Panel.upper ? dropPreview : null,
                hoveringData:
                    dropPreview?.$2 == Panel.upper ? hoveringData : null,
                onDragStart: onDragStart,
                dragStart: dragStart?.$2 == Panel.upper ? dragStart : null,
              ),
            ),
          ),
          Positioned(
            height: 2,
            width: constraints.maxWidth,
            top: constraints.maxHeight / 2,
            child: const ColoredBox(
              color: Colors.black,
            ),
          ),
          Positioned(
            height: constraints.maxHeight / 2,
            width: constraints.maxWidth,
            bottom: 0,
            child: MyDropRegion(
              updateDropPreview: updateDropPreview,
              columns: widget.columns,
              childSize: itemSize,
              onDrop: drop,
              setExternalData: setExternalData,
              panel: Panel.lower,
              child: ItemPanel(
                crossAxisCount: widget.columns,
                spacing: widget.itemSpacing,
                items: lower,
                dropPreview:
                    dropPreview?.$2 == Panel.lower ? dropPreview : null,
                hoveringData:
                    dropPreview?.$2 == Panel.lower ? hoveringData : null,
                panel: Panel.lower,
                onDragStart: onDragStart,
                dragStart: dragStart?.$2 == Panel.lower ? dragStart : null,
              ),
            ),
          ),
        ],
      );
    });
  }
}
