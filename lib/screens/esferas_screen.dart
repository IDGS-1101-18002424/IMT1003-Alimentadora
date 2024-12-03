import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EsferasScreen extends StatelessWidget {
  const EsferasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Esferas')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Alimentadora')
            .doc('Esferas')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No hay datos disponibles.'));
          }

          final data = snapshot.data!;

          return ListView(
            children: [
              ListTile(title: Text('Azules: ${data['Azules']}')),
              ListTile(title: Text('Rojas: ${data['Rojas']}')),
              ListTile(title: Text('Totales: ${data['Totales']}')),
              ListTile(title: Text('Verdes: ${data['Verdes']}')),
            ],
          );
        },
      ),
    );
  }
}
