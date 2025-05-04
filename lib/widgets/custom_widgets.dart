
import 'package:flutter/material.dart';

class CustomScaffold extends StatefulWidget {

  const CustomScaffold({super.key, this.child, this.showBackArrow = true});

  final Widget? child;
  final bool showBackArrow;

  @override
  State<CustomScaffold> createState() => _CustomScaffold();
}

class _CustomScaffold extends State<CustomScaffold> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        actionsIconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: widget.showBackArrow,
      ),
       extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
          SafeArea(
            child: widget.child ?? const SizedBox(),
          ),
        ]
      ),

    );
  }
}
