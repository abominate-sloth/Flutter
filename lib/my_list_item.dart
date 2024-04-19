import 'package:flutter/material.dart';
import 'package:lab2/fish_describe.dart';
import 'item.dart';

class MyItem extends StatefulWidget {
  final Item item;

  MyItem(this.item);

  @override
  _MyItemState createState() => _MyItemState();
}

class _MyItemState extends State<MyItem> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FishScreen(item: widget.item),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 100,
          color: Colors.deepPurple[100],
          child: Row(
            children: [
              Icon(Icons.account_tree_outlined),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.title,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            expanded = !expanded;
                          });
                        },
                        child: Text(
                          widget.item.desc,
                          maxLines: expanded ? null : 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}