import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _authenticateUser();
  }

  Future<void> _authenticateUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'not@hotmail.com',
        password: 'simona',
      );
      setState(() {
        _isAuthenticated = true;
      });
    } catch (e) {
      print('Error al autenticar: $e');
      setState(() {
        _isAuthenticated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: _isAuthenticated
          ? HomeScreen()
          : Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta de Datos'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('Alimentadora').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No hay datos disponibles.'));
          }

          // Obtener datos de los módulos
          final esferasSnapshot =
              snapshot.data!.docs.where((doc) => doc.id == 'Esferas').toList();
          final esferasData = esferasSnapshot.isNotEmpty
              ? esferasSnapshot.first.data() as Map<String, dynamic>?
              : null;

          final indicadoresSnapshot = snapshot.data!.docs
              .where((doc) => doc.id == 'Indicadores')
              .toList();
          final indicadoresData = indicadoresSnapshot.isNotEmpty
              ? indicadoresSnapshot.first.data() as Map<String, dynamic>?
              : null;

          final botonesSnapshot =
              snapshot.data!.docs.where((doc) => doc.id == 'Botones').toList();
          final botonesData = botonesSnapshot.isNotEmpty
              ? botonesSnapshot.first.data() as Map<String, dynamic>?
              : null;

          final almacenamientoSnapshot = snapshot.data!.docs
              .where((doc) => doc.id == 'Almacenamiento')
              .toList();
          final almacenamientoData = almacenamientoSnapshot.isNotEmpty
              ? almacenamientoSnapshot.first.data() as Map<String, dynamic>?
              : null;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              if (botonesData != null) _buildBotonesModule(botonesData),
              if (esferasData != null) _buildEsferasModule(esferasData),
              if (almacenamientoData != null)
                _buildAlmacenamientoModule(almacenamientoData),
              if (indicadoresData != null)
                _buildIndicadoresModule(indicadoresData),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEsferasModule(Map<String, dynamic> esferasData) {
    final int azules = esferasData['Azules'] ?? 0;
    final int rojas = esferasData['Rojas'] ?? 0;
    final int verdes = esferasData['Verdes'] ?? 0;
    final int total = azules + rojas + verdes;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Esferas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
              ),
              title: Text('Azules'),
              trailing: Text(
                '$azules',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red,
              ),
              title: Text('Rojas'),
              trailing: Text(
                '$rojas',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green,
              ),
              title: Text('Verdes'),
              trailing: Text(
                '$verdes',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                '$total',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicadoresModule(Map<String, dynamic> data) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Text(
            'Indicadores',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListTile(
            leading: Icon(Icons.warning, color: Colors.orange),
            title: Text(
                'Alarma Material: ${data['Alarma-Material'] ? "Activa" : "Inactiva"}'),
          ),
          ListTile(
            leading: Icon(Icons.power, color: Colors.green),
            title: Text(
                'Estado Sistema: ${data['Estado-Sistema'] ? "Encendido" : "Apagado"}'),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonesModule(Map<String, dynamic> data) {
    final isEncendido = data['Arranque'] ?? false;

    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Text(
            'Botones',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.radio_button_checked,
              color: isEncendido ? Colors.green : Colors.red,
            ),
            title: Text(isEncendido ? 'Encendido' : 'Apagado'),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isEncendido ? Colors.red : Colors.green,
              ),
              onPressed: () async {
                // Actualizamos el campo 'Arranque' en la colección 'Botones'
                await FirebaseFirestore.instance
                    .collection('Alimentadora')
                    .doc('Botones')
                    .update({'Arranque': !isEncendido});

                // Actualizamos el campo 'Estado-Sistema' en la colección 'Indicadores'
                await FirebaseFirestore.instance
                    .collection('Alimentadora')
                    .doc('Indicadores')
                    .update({'Estado-Sistema': !isEncendido});
              },
              child: Text(isEncendido ? 'Apagar' : 'Encender'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlmacenamientoModule(Map<String, dynamic> data) {
    // Declara explícitamente las variables con un tipo adecuado
    final a = data['A'] ?? false; // Si no existe, usamos false por defecto
    final r = data['R'] ?? false; // Lo mismo para 'R'
    final v = data['V'] ?? false; // Y para 'V'

    // Convertir los valores booleanos a 'Activo' o 'Inactivo'
    final aStatus = a ? 'Activo' : 'Inactivo';
    final rStatus = r ? 'Activo' : 'Inactivo';
    final vStatus = v ? 'Activo' : 'Inactivo';

    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Text(
            'Almacenamiento',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListTile(
            leading: Icon(Icons.storage, color: Colors.indigo),
            title: Text('Azules: $aStatus'),
          ),
          ListTile(
            leading: Icon(Icons.storage, color: Colors.red),
            title: Text('Rojas: $rStatus'),
          ),
          ListTile(
            leading: Icon(Icons.storage, color: Colors.green),
            title: Text('Verdes: $vStatus'),
          ),
        ],
      ),
    );
  }
}
