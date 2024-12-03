import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BotonesScreen extends StatelessWidget {
  const BotonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Botones')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Alimentadora')
            .doc('Botones')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No hay datos disponibles.'));
          }

          final data = snapshot.data!;

          return ListTile(
            title: Text('Arranque: ${data['Arranque']}'),
          );
        },
      ),
    );
  }
}
