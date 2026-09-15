import 'package:flutter/material.dart';

import 'particle_fx_showcase_page.dart';

void main() {
  runApp(
    const ParticleFxShowcaseApp(),
  );
}

class ParticleFxShowcaseApp
    extends StatelessWidget {
  const ParticleFxShowcaseApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Particle FX Showcase',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home:
      const ParticleFxShowcasePage(),
    );
  }
}