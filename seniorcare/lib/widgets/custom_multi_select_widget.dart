import 'package:flutter/material.dart';

class MultiSelect extends StatefulWidget {
  final List<String> items;
  final Function updateHealthRisks;
  final List<dynamic> healthRisks;
  final Color? color;

  const MultiSelect(
      {super.key,
      required this.items,
      required this.updateHealthRisks,
      required this.healthRisks,
      this.color});

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final List<String> _selectedItems = [];
  bool editing = false;

  String selectedText = "";

  @override
  Widget build(BuildContext context) {
    if (widget.healthRisks.isNotEmpty &&
        _selectedItems.isEmpty &&
        editing == false) {
      for (var element in widget.healthRisks) {
        _selectedItems.add(element.toString());
      }
    }

    editing = true;

    Color widgetColor = widget.color == null
        ? const Color.fromRGBO(108, 99, 255, 1)
        : widget.color as Color;

    return Container(
        width: 310,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(color: widgetColor)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: ExpansionTile(
              trailing: Icon(Icons.arrow_drop_down, color: widgetColor),
              title: Text(_selectedItems.isEmpty ? "Select" : _selectedItems[0],
                  style: TextStyle(color: widgetColor)),
              children: <Widget>[
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: _ViewItem(
                            color: widgetColor,
                            item: widget.items[index],
                            selected: (val) {
                              setState(() {
                                selectedText = val;
                                if (_selectedItems.contains(val)) {
                                  _selectedItems.remove(val);
                                } else {
                                  _selectedItems.add(val);
                                }
                              });
                              widget.updateHealthRisks(_selectedItems);
                            },
                            itemSelected:
                                _selectedItems.contains(widget.items[index]),
                          ));
                    })
              ],
            )));
  }
}

class _ViewItem extends StatelessWidget {
  String item;
  bool itemSelected;
  final Function(String) selected;
  Color color;

  _ViewItem(
      {required this.item,
      required this.itemSelected,
      required this.selected,
      required this.color});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Padding(
        padding: EdgeInsets.only(
            left: size.width * 0.05,
            right: size.width * 0.098,
            bottom: size.height * 0.01),
        child: Row(
          children: <Widget>[
            SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                    activeColor: color,
                    value: itemSelected,
                    onChanged: (val) {
                      selected(item);
                    })),
            SizedBox(width: size.width * 0.025),
            Text(item, style: TextStyle(color: color))
          ],
        ));
  }
}
