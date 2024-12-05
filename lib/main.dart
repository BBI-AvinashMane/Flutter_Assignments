import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Counter Application'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter=0;
    });
  }
  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }
  


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              const Text(
              'Value:',
              style: TextStyle(fontSize:24.0,
              ),
            ),
            Text(
              '$_counter',
              // style: Theme.of(context).textTheme.headlineMedium,
              style: const TextStyle(fontSize: 40.0,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 113, 3, 149),),
            ),
          ],
        ),
      ),
      //------------------using floating buttons for similar operations----------------------
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left:30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          
          children: [

         FloatingActionButton(
          onPressed: _resetCounter,
          tooltip: 'reset',
          child: const Icon(Icons.refresh),
        ),Expanded(child: Container()),
        FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), 
        Expanded(child: Container()),
        FloatingActionButton(
          onPressed: _decrementCounter,
          tooltip: 'decrement',
          child: const Icon(Icons.remove),
        ), 
        ],
        ),
      )
    );
  }
}
