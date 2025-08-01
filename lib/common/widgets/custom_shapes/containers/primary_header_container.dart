import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../curved_edges/curved_edges_widget.dart';
import 'circular_container.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgeWidget(
      child: Container(
        color: TColors.primaryNew,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(top: -150, right: -250,child: TCircularContainer(backgroundColor: TColors.white.withAlpha(25))),
            Positioned(top: 100, right: -300,child: TCircularContainer(backgroundColor: TColors.white.withAlpha(25))),
            child,
          ],
        ),
      ),
    );
  }
}

