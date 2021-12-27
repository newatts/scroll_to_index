import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

//this code is to display cards, many of them, but only builds those that are visible,
//also it can enter at a non-zero card and there is a button to navigate to another card.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final itemController = ItemScrollController();
  final itemListener = ItemPositionsListener.create();
  //final itemKey = GlobalKey();

  Future scrollToItem(int index, {bool isAnimating = false}) async {
    //final context = itemKey.currentContext!;
    final double alignment = 0;

    if (isAnimating) {
      await itemController.scrollTo(
        index: index,
        alignment:
            0.5, //sets where on the screen the card requested appears.  i.e 0 is at the top.
        duration: Duration(seconds: 1), //time to scroll to selected card
      );
    } else {
      itemController.jumpTo(index: index, alignment: alignment);
    }

    //   await Scrollable.ensureVisible(
    //set for the position after the scroll to button pressed.
    //     context,
    //    alignment: 0.5,
    //    duration: Duration(seconds: 1),
    //  );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) =>
        scrollToItem(300)); //this determines which card is displayed on entry.

    /*   itemListener.itemPositions.addListener(() {
      final indicies = itemListener.itemPositions.value
          .where((item) {
            final isTopVisible = item.itemLeadingEdge >= 0;
            final isBottomVisible = item.itemLeadingEdge <= 1;
            return isTopVisible && isBottomVisible;
          })
          .map((item) => item.index)
          .toList();

      print(indicies);
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ScrollablePositionedList.builder(
        itemCount: 5000, //sets the number of cards
        itemBuilder: (context, index) => buildCard(index),
        itemScrollController: itemController, //scrollable for the cards
        itemPositionsListener: itemListener,
      ),
      floatingActionButton: FloatingActionButton(
        //corner button for user to scroll to...
        child: Icon(Icons.arrow_upward), //visual button.
        onPressed: () => scrollToItem(
            1000), //this is the index that the floating action sends the user to
      ),
    );
  }

  Widget buildCard(int index) => Container(
      height: index % 2 == 0
          ? 100
          : 100, //if statement to vary the size of the cards by the index.
      child: Card(
          child: Center(
        child: Text(
          'Item $index',
          style: TextStyle(fontSize: 28),
        ),
      )));
}
