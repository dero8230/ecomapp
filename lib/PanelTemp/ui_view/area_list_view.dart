import 'package:flutter/material.dart';

import '../cpanelTheme.dart';

class AreaListView extends StatefulWidget {
  const AreaListView(
      {Key? key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation,
      this.isFromAdmin})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final bool? isFromAdmin;
  @override
  _AreaListViewState createState() => _AreaListViewState();
}

class _AreaListViewState extends State<AreaListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<String> areaListData = <String>[
    'https://firebasestorage.googleapis.com/v0/b/weshop8230.appspot.com/o/products%2Fheadphones_2.png?alt=media&token=eb62b4a0-9f0b-4794-8b27-e78a1ce38ba5',
    'https://firebasestorage.googleapis.com/v0/b/weshop8230.appspot.com/o/products%2Fheadphones_3.png?alt=media&token=b7b9c5b6-c450-438d-8974-0598cbba6d5a',
    'https://firebasestorage.googleapis.com/v0/b/weshop8230.appspot.com/o/products%2Fheadphones.png?alt=media&token=eb70361e-ba2b-4443-b248-54648cc32d23',
    'https://firebasestorage.googleapis.com/v0/b/weshop8230.appspot.com/o/products%2Fbag_5.png?alt=media&token=ac408380-2064-4053-bce9-33ded9f00566',
  ];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: GridView(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: List<Widget>.generate(
                    areaListData.length,
                    (int index) {
                      final int count = areaListData.length;
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animationController!,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      );
                      animationController?.forward();
                      return AreaView(
                        imagepath: areaListData[index],
                        animation: animation,
                        animationController: animationController!,
                        isFromAdmin: widget.isFromAdmin,
                      );
                    },
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24.0,
                    crossAxisSpacing: 24.0,
                    childAspectRatio: 1.0,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AreaView extends StatelessWidget {
  const AreaView({
    Key? key,
    this.imagepath,
    this.animationController,
    this.animation,
    this.isFromAdmin,
  }) : super(key: key);

  final String? imagepath;
  final bool? isFromAdmin;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: FitnessAppTheme.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: FitnessAppTheme.grey.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  splashColor: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.2),
                  onTap: () {},
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: isFromAdmin != null
                            ? SizedBox.shrink()
                            : Image.network(
                                imagepath!,
                                width: 100,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                  Icons.error,
                                  color: FitnessAppTheme.nearlyDarkBlue,
                                  size: 64,
                                ),
                                loadingBuilder: (context, child, progress) {
                                  return progress == null
                                      ? child
                                      : Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                progress.cumulativeBytesLoaded /
                                                    progress.expectedTotalBytes!
                                                        .toInt()
                                                        .toDouble(),
                                          ),
                                        );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
