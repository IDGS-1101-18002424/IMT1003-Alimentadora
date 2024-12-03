import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IndicadoresScreen extends StatelessWidget {
  const IndicadoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Indicadores')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Alimentadora')
            .doc('Indicadores')
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
              ListTile(
                  title: Text('Alarma Material: ${data['Alarma-Material']}')),
              ListTile(
                  title: Text('Estado Sistema: ${data['Estado-Sistema']}')),
            ],
          );
        },
      ),
    );
  }
}
