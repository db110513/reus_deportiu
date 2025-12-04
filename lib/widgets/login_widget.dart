import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/show_snackbar.dart';
import 'package:reus_deportiu/widgets/to_signup.dart';
import '../styles/app_styles.dart';
import '../screens/menu.dart';
import '../providers/auth_provider.dart';


class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final auth = context.read<AuthProvider>();

    try {
      await auth.login(emailController.text.trim(), passController.text.trim());
      if (auth.isLoggedIn) {
        showSnackBar(context, 'Sessió iniciada correctament!');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Menu()));
      }
    } catch (e) {
      showSnackBar(context, 'Error a l\'iniciar sessió: $e');
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (auth.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Hola!', style: AppStyles.logInTitle),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54, width: 1.5)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Contrasenya',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54, width: 1.5)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => _login(context),
                  child: const Text('Inicia Sessió'),
                ),
                AppStyles.sizedBoxHeight60,
                const ToSignUp(),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
}
