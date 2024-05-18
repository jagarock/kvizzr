import 'package:flutter/material.dart';
import 'category_screen.dart';

class DetaljkunnskapScreen extends StatelessWidget {
  const DetaljkunnskapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KvizzR Dypere'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCategoryButton(context, 'Musikk'),
            _buildCategoryButton(context, 'Teknologi'),
            _buildCategoryButton(context, 'Verdensrommet'),
            _buildCategoryButton(context, 'Mennesket'),
            _buildCategoryButton(context, 'Historie'),
            _buildCategoryButton(context, 'Geografi'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, String subcategory) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryScreen(category: subcategory)),
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          textStyle: const TextStyle(fontSize: 20.0),
        ),
        child: Text(subcategory),
      ),
    );
  }
}
