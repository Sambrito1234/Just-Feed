import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart';
import 'registrationpage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Check if the user is already logged in
  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();
  }

  // Check if the user is logged in already
  void _checkUserLoggedIn() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // If the user is already logged in, navigate to the HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  // Login method
  void _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Sign in the user using email and password
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // After successful login, navigate to HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Login failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.orange, // Custom color for consistency
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Logo/Title
                Center(
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    height: 120,
                  ),
                ),
                const SizedBox(height: 40),

                // Email Input
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your email' : null,
                ),
                const SizedBox(height: 10),

                // Password Input
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: !_isPasswordVisible,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your password' : null,
                ),
                const SizedBox(height: 20),

                // Login Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _loginUser,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.orange, // Consistent button color
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Login'),
                ),

                // Register link
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to the RegistrationPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegistrationPage()),
                      );
                    },
                    child: const Text('New user? Register here'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
