import 'package:flutter/material.dart';

class JcphDrawer extends StatelessWidget {
  const JcphDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceColor = colorScheme.surface;
    return Drawer(
        child: Container(
      color: surfaceColor,
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            child: SizedBox.expand(
              child: Stack(
                children: [
                  Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      decoration:
                      BoxDecoration(gradient: LinearGradient(
                        colors: [colorScheme.secondary, colorScheme.secondaryVariant],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ))),
                  Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      decoration:
                      BoxDecoration(image: DecorationImage(
                          image:AssetImage('images/banner/checkerboard.png'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(colorScheme.secondaryVariant.withAlpha(50), BlendMode.modulate)
                      ))
                  ),
                  Padding(padding: EdgeInsets.all(5.0),
                    child: Stack(
                      children:[
                        Transform.translate(
                          offset: Offset(-2, 2),
                          child: Container(
                              width: double.maxFinite,
                              height: double.maxFinite,
                              decoration:
                              BoxDecoration(image: DecorationImage(
                                  image: AssetImage('images/banner/bannerInfo.png'),
                                  colorFilter: ColorFilter.mode(Color.fromARGB(100, 0, 0, 0), BlendMode.modulate)
                              ))),
                        ),
                        Container(
                            width: double.maxFinite,
                            height: double.maxFinite,
                            decoration:
                            BoxDecoration(image: DecorationImage(
                              image: AssetImage('images/banner/bannerTextOnly.png'),
                            ))),
                        Container(
                            width: double.maxFinite,
                            height: double.maxFinite,
                            decoration:
                            BoxDecoration(image: DecorationImage(
                                image: AssetImage('images/banner/bannerInfo.png'),
                                colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.modulate)
                            ))),
                      ]
                    ),
                  )
                ],
              ),
            ),
          ),
          Material(
            color: surfaceColor,
            child: ListTile(
              leading: Icon(Icons.sticky_note_2),
              title: Text("Browse Stickers"),
              onTap: () {
                // TODO: Change navigator change screen animation
                Navigator.pushReplacementNamed(context, "stickers");
                // setState(() { });
              },
            ),
          ),
          Material(
            color: surfaceColor,
            child: ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text("Payment"),
              onTap: () {
                Navigator.pushReplacementNamed(context, "payment");
              },
            ),
          ),
          Material(
            color: surfaceColor,
            child: ListTile(
              leading: Icon(Icons.design_services),
              title: Text("Design Commissions"),
              onTap: () {},
            ),
          ),
          Material(
            color: surfaceColor,
            child: ListTile(
              leading: Icon(Icons.contact_support_rounded),
              title: Text("FAQ"),
              onTap: () {
                Navigator.pushReplacementNamed(context, "faq");
              },
            ),
          ),
          Material(
            color: surfaceColor,
            child: ListTile(
              leading: Icon(Icons.mail),
              title: Text("Contact Us"),
              onTap: () {},
            ),
          ),
        ],
      ),
    ));
  }
}
