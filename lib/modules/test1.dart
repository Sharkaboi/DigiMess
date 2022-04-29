import 'package:flutter/material.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({Key key}) : super(key: key);

  @override
  _MembershipScreenState createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  @override
  Widget build(BuildContext context) {
    Values character = Values.val1;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 30.0),
        child: Column(
          children: [
            ArrowHeading(
              header: 'Membership',
            ),
            CreditSystem(
              onChanged: (Values value) {
                setState(() {
                  character = value;
                });
              },
              currentValue: character,
            ),
            GestureDetector(
              onTap: () {
                /***
                 * Setup routes in main.dart like so

                    MaterialApp(
                    routes: {
                    MainScreenPayment.route: (context) => MainScreenPayment(),
                    },
                    )

                 * then in MainScreenPayment get the value as so

                    final args = ModalRoute.of(context)!.settings.arguments as Values;

                 * then show payment screen based on the option that was chosen
                 ***/
                // then
                Navigator.pushNamed(context, MainScreenPayment.route,
                    arguments: character);
              },
              child: ButtonName(
                buttonName: 'continue',
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum Values { val1, val2, val3 }

class CreditSystem extends StatelessWidget {
  final Function(Values) onChanged;
  final Values currentValue;

  const CreditSystem({Key key, this.onChanged, this.currentValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RadioListTile<Values>(
          title: Text('Lafayette'),
          value: Values.val1,
          groupValue: currentValue,
          onChanged: (Values value) {
            onChanged(value);
          },
        ),
        RadioListTile<Values>(
          title: Text('Thomas Jefferson'),
          value: Values.val2,
          groupValue: currentValue,
          onChanged: (Values value) {
            onChanged(value);
          },
        ),
        RadioListTile<Values>(
          title: Text('Thomas Jefferson'),
          value: Values.val3,
          groupValue: currentValue,
          onChanged: (Values value) {
            onChanged(value);
          },
        ),
      ],
    );
  }
}
