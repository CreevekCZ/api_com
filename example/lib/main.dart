import 'package:example/models/crew.dart';
import 'package:flutter/material.dart';
import 'package:api_com/api_com.dart';

void main() {
  Com.config = ComConfig(
    mainHost: 'api.spacexdata.com/v4',
    preferredProtocol: 'https',
    onMakeRequestComplete: (response) {
      // ignore: avoid_print
      print('Request completed with status code: ${response.statusCode}');
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'API_COM Demo'),
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
  bool isLoading = false;
  List<Crew> crewList = [];

  @override
  void initState() {
    super.initState();
    fetchCrew();
  }

  void startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  Future<void> stopLoading() async {
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchCrew() async {
    startLoading();

    final request = ComRequest<List<Crew>>(
      method: HttpMethod.get,
      uri: '/crew',
      decoder: (rawPayload, status) {
        return List.from(rawPayload).map((e) {
          return Crew.fromJson(e);
        }).toList();
      },
    );

    final response = await Com.makeRequest<List<Crew>>(request);

    isLoading = false;

    if (response.isSuccess) {
      setState(() {
        crewList = response.payload ?? [];
      });
    } else {
      Future.sync(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(response.response?.body ?? 'Failed to fetch crew list'),
          ),
        );
      });
    }

    stopLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Crew List'),
        actions: [
          IconButton(
            onPressed: fetchCrew,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Visibility(
        visible: !isLoading,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: ListView.builder(
          itemCount: crewList.length,
          itemBuilder: (BuildContext context, int index) {
            final crew = crewList[index];
            return ListTile(
              leading: Image.network(crew.image),
              title: Text(crew.name),
              subtitle: Text(crew.agency),
              trailing: Text(crew.status),
            );
          },
        ),
      ),
    );
  }
}
