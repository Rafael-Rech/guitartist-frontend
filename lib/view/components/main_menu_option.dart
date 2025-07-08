import 'package:flutter/material.dart';

class MainMenuOption extends StatelessWidget {
  const MainMenuOption(this.style,
      {super.key,
      required this.optionImage,
      required this.optionText,
      required this.reverse,
      this.route});

  final int style;
  final ImageProvider<Object> optionImage;
  final String optionText;
  final bool reverse;
  final Widget? route;

  @override
  Widget build(BuildContext context) {
    late Widget button;
    switch (style) {
      case 1:
      // Old Style Button
        button = Container(
          width: MediaQuery.of(context).size.width * 0.85,
          color: const Color.fromARGB(255, 250, 220, 153),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: (reverse)
                ? <Widget>[
                    Image(
                      image: optionImage,
                      width: MediaQuery.of(context).size.width * 0.35,
                    ),
                    Text(optionText),
                  ]
                : <Widget>[
                    Text(optionText),
                    Image(
                      image: optionImage,
                      width: MediaQuery.of(context).size.width * 0.35,
                    ),
                  ],
          ),
        );
        break;
      case 2:
      // Bigger button
        button = Container(
          decoration: BoxDecoration(
            // color: MyColors.secondary3,
            borderRadius: BorderRadius.circular(10),
          ),
          height: MediaQuery.of(context).size.height * 0.10,
          width: MediaQuery.of(context).size.width * 0.85,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: (reverse)
                ? [
                    SizedBox(
                      width: 1,
                    ),
                    Text(
                      optionText,
                      style: TextStyle(fontSize: 40),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: optionImage,
                          fit: BoxFit.fitHeight,
                          alignment: FractionalOffset.centerLeft,
                        ),
                      ),
                    ),
                  ]
                : [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: optionImage,
                          fit: BoxFit.fitHeight,
                          alignment: FractionalOffset.centerRight,
                        ),
                      ),
                    ),
                    Text(
                      optionText,
                      style: TextStyle(fontSize: 40),
                    ),
                    SizedBox(
                      width: 1,
                    ),
                  ],
          ),
        );
        break;
      case 3:
      // Square button
        button = Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            // color: MyColors.secondary2,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.33,
                  height: MediaQuery.of(context).size.width * 0.33,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: optionImage,
                      fit: BoxFit.fitHeight,
                      alignment: FractionalOffset.center,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 10,
                child: Text(
                  optionText,
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ],
          ),
        );
        break;
      default:
        button = Container();
        break;
    }
    return GestureDetector(
      onTap: () {
        if (route != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => route!));
        }
      },
      child: button,
    );
  }
}
