import 'package:commander/Models/element.dart';
import 'package:commander/globals.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key, required this.base});
  final MapElement base;

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Building blocks: $myBlocks')
          ],
        ),
      ),
    );
  }
}