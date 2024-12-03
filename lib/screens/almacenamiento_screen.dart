import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlmacenamientoScreen extends StatelessWidget {
  const AlmacenamientoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Almacenamiento')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Alimentadora')
            .doc('Almacenamiento')
            .collection('Almacenamiento')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay datos disponibles.'));
          }

          final data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final almacen = data[index];
              return ListTile(
                title: Text('A: ${almacen['A']}'),
                subtitle: Text('Almacenado: ${almacen['Almacenado']}'),
                trailing: Text('R: ${almacen['R']}, V: ${almacen['V']}'),
              );
            },
          );
        },
      ),
    );
  }
}
