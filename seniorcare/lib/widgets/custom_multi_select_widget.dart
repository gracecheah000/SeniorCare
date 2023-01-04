import 'package:flutter/material.dart';

class MultiSelect extends StatefulWidget {
  final List<String> items;
  final updateHealthRisks;
  const MultiSelect(
      {super.key, required this.items, required this.updateHealthRisks});

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final List<String> _selectedItems = [];
  String selectedText = "";

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 310,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(color: const Color.fromRGBO(108, 99, 255, 1))),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: ExpansionTile(
              trailing: const Icon(Icons.arrow_drop_down,
                  color: Color.fromRGBO(108, 99, 255, 1)),
              title: Text(_selectedItems.isEmpty ? "Select" : _selectedItems[0],
                  style: TextStyle(color: Color.fromRGBO(108, 99, 255, 1))),
              children: <Widget>[
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          margin: EdgeInsets.only(bottom: 8),
                          child: _ViewItem(
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

  _ViewItem(
      {required this.item, required this.itemSelected, required this.selected});

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
                    activeColor: Color.fromRGBO(108, 99, 255, 1),
                    value: itemSelected,
                    onChanged: (val) {
                      selected(item);
                    })),
            SizedBox(width: size.width * 0.025),
            Text(item, style: TextStyle(color: Color.fromRGBO(108, 99, 255, 1)))
          ],
        ));
  }
}
