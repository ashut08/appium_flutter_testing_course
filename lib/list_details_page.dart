import 'package:appiumtesting/list_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.model});
  final ProductModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${model.name} details")),
      body: Center(
        child: Text(
          key: const ValueKey('detail_text'),
          'You have opened ${model.name} with price ${model.price}',
          style: GoogleFonts.roboto(),
        ),
      ),
    );
  }
}
