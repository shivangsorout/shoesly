import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoesly_app/constants/routes.dart';
import 'package:shoesly_app/extensions/context_extension.dart';
import 'package:shoesly_app/firebase_options.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_bloc.dart';
import 'package:shoesly_app/services/firebase_firestore_service/firebase_service.dart';
import 'package:shoesly_app/views/all_reviews_view.dart';
import 'package:shoesly_app/views/cart_view.dart';
import 'package:shoesly_app/views/home_view.dart';
import 'package:shoesly_app/views/order_summary_view.dart';
import 'package:shoesly_app/views/product_detail/product_detail_view.dart';
import 'package:shoesly_app/views/product_filter_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FirebaseBloc(FirebaseService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shoesly',
        theme: ThemeData(
          fontFamily: 'Urbanist',
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 21,
              color: Color(0xff101010),
            ),
          ),
          textTheme: TextTheme(
            bodyMedium: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 0.0228 * context.mqSize.height,
                color: const Color(0xff101010)),
          ),
        ),
        routes: {
          homeRoute: (context) => const HomeView(),
          productDetailRoute: (context) => const ProductDetailView(),
          productFilterRoute: (context) => const ProductFilterView(),
          allReviewsRoute: (context) => const AllReviewsView(),
          cartRoute: (context) => const CartView(),
          orderSummaryRoute: (context) => const OrderSummaryView(),
        },
        home: const HomeView(),
      ),
    );
  }
}
