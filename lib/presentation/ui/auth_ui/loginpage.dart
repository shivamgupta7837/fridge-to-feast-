import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridge_to_feast/logic/cubit/auth/auth_cubit.dart';
import 'package:fridge_to_feast/presentation/home_page.dart';
import 'package:fridge_to_feast/presentation/ui/features/app_goto_screen.dart';
import 'package:fridge_to_feast/services/login_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  LoginService userLogin = LoginService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return const CircularProgressIndicator();
            } else if (state is AuthAuthenticatedState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Lottie.asset(
                          "assets/animations/login-animation.json",
                          height: 300,
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        Text(
                          "Fridge to Feast",
                          style: GoogleFonts.alexandria(
                              fontSize: 23,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueGrey.shade700),
                        ),
                        Text(
                          "Authentication",
                          style: GoogleFonts.alexandria(
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueGrey.shade800),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shadowColor: Colors.black,
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.7, 50)),
                        onPressed: () async {
                          await context
                              .read<AuthCubit>()
                              .login(context: context);
                          if (await userLogin.isUserLoggedIn()) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AppGoToScreen()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.deepPurple.shade300,
                              content: Text(
                                "Not be able to Login",
                                style: GoogleFonts.roboto(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              duration: const Duration(seconds: 2),
                            ));
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/logos/google_logo.png",
                              width: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Sign in with Google",
                              style: GoogleFonts.alexandria(
                                  color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ))
                  ],
                ),
              );
            } else if (state is AuthErrorState) {
              return Text("${state.message.toString()}");
            } else {
              return Text(state.toString());
            }
          },
        ),
      ),
    );
  }
}

