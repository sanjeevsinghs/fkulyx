import 'package:flutter/material.dart';
import 'package:kulyx/widgets/images.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Meal Planner',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              const Text(
                'Plan your weekly meals and track diet goals.',
                style: TextStyle(color: Color(0xFF666666)),
              ),
              const SizedBox(height: 14),

              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 97, 34, 34),
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  image: DecorationImage(
                    image: AssetImage(AssetsImages.culinaryTagline),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover new recipes and meal ideas.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to meal planner screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color.fromARGB(255, 97, 34, 34),
                      ),
                      child: Text(
                        'Get Started',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
