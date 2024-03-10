import 'package:flutter/material.dart';

class Task extends StatelessWidget {
  final String index;
  final Widget title;
  final Widget desc;
  final Widget options;
  final Function()? onTap;
  final Function()? onLongPress;
  const Task({
    super.key,
    required this.index,
    required this.title,
    required this.desc,
    required this.options,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            // color: Colors.grey[600],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    // backgroundColor: Colors.black,
                    child: Text(index),
                  ),
                  options,
                ],
              ),
              title,
              desc,
            ],
          ),
        ),
      ),
    );
  }
}
