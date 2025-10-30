import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_shake_widget/shake_widget.dart';
import 'package:flutter/services.dart';


bool strongpassword = false;
bool earlybird = false;
bool profilecompleter = false;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signup Adventure',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome!',
              style: TextStyle(fontSize: 52),
            ),
            SizedBox(height: 40,
            child: AnimatedTextKit(
              animatedTexts: [
              RotateAnimatedText('Make your own account!', textStyle: TextStyle(fontSize: 32,)),
              RotateAnimatedText('Begin your signup adventure!', textStyle: TextStyle(fontSize: 32,)),
              RotateAnimatedText('Signup today!', textStyle: TextStyle(fontSize: 32,)),
            ],
            repeatForever: true,
            )
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                );
              },
              child: Text('Go to Signup'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String selectedimage = 'assets/profile1.jpg';
  
  // Shake keys for each form field
  final GlobalKey<ShakeWidgetState> _nameShakeKey = GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> _emailShakeKey = GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> _passwordShakeKey = GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> _confirmPasswordShakeKey = GlobalKey<ShakeWidgetState>();

  double _passwordStrength = 0.0;
  String _passwordStrengthText = 'Enter a password';

  bool hasname = false;
  bool haseamil = false;
  bool haspassword = false;
  bool hasconfirmpassword = false;

  double status = 0.0;
  String message = '';

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(updatePasswordStrength);
    _nameController.addListener(() {
      setState(() {
        hasname = _nameController.text.isNotEmpty;
        updateStatus();
      });
    });
    _emailController.addListener(() {
      setState(() {
        haseamil = _emailController.text.isNotEmpty;
        updateStatus();
      });
    });
    _confirmPasswordController.addListener(() {
      setState(() {
        hasconfirmpassword = _confirmPasswordController.text.isNotEmpty;
        updateStatus();
      });
    }); 
  }

  @override
  void dispose() {
    _passwordController.removeListener(updatePasswordStrength);
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void updatePasswordStrength() {
    setState(() {
      haspassword = _passwordController.text.isNotEmpty;
      updateStatus();
      String password = _passwordController.text;
      _passwordStrength = calculatePasswordStrength(password);
      _passwordStrengthText = getPasswordStrengthText(_passwordStrength);
    });
  }

  double calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0.0;

    double strength = 0.0;
    strength += (password.length / 12).clamp(0.0, 0.4);
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.15;
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.15;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.15;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.15;
    return strength.clamp(0.0, 1.0);
  }

  String getPasswordStrengthText(double strength) {
    if (strength == 0.0) return 'Enter a password';
    if (strength < 0.3) return 'Weak';
    if (strength < 0.6) return 'Fair';
    if (strength < 0.8) return 'Good';
    strongpassword = true;
    return 'Strong';
  }

  Color getPasswordStrengthColor(double strength) {
    if (strength < 0.3) return Colors.red;
    if (strength < 0.6) return Colors.orange;
    if (strength < 0.8) return Colors.yellow;
    return Colors.green;
  }

  void updateStatus() {
    setState(() {
      status = (hasname ? 0.25 : 0) +
               (haseamil ? 0.25 : 0) +
               (haspassword ? 0.25 : 0) +
               (hasconfirmpassword ? 0.25 : 0);
      if (status == 1.0) {
      message = 'Ready for Adventure!';
      HapticFeedback.heavyImpact();
    } else if (status >= .75) {
      message = 'Almost Done!';
      HapticFeedback.mediumImpact();
    } else if (status >= .5) {
      message = 'Halfway There!';
      HapticFeedback.lightImpact();
    } else if (status == .25) {
      message = 'Great Start!';
      HapticFeedback.lightImpact();
    } else {
      message = '';
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
        child: Form(
          key: _formKey,
          child: SizedBox( width: 400,
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Welcome Message
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text('Adventure Progress Tracker'),
              LinearProgressIndicator(
                value: (status),
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
                minHeight: 8,
              ),
              Text(message),
              const SizedBox(height: 20),

              // Name Field
              ShakeWidget(
                key: _nameShakeKey,
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'You forgot to tell us your name!';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Email Field
              ShakeWidget(
                key: _emailShakeKey,
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Oops! You forgot to enter your email';
      }
      if (!value.contains('@')) {
        _emailController.text = '';
        return 'Enter a valid email! (Try using an @!)';
      }
      return null;
    },
                ),
              ),
              const SizedBox(height: 16),

              // Date of Birth Field (Optional)
              TextFormField(
                controller: _dobController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth (Optional)',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                  hintText: 'Select your date of birth',
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().subtract(Duration(days: 365 * 18)), // Default to 18 years ago
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dobController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    });
                  }
                },
                // No validator - field is optional
              ),
              const SizedBox(height: 16),

              // Password Field
              ShakeWidget(
                key: _passwordShakeKey,
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'You didn\'t enter your secret password!';
                    }
                    if (value.length < 6) {
                      _passwordController.text = '';
                      return 'Try to make the password at least 6 characters!';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Password Strength:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    _passwordStrengthText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: getPasswordStrengthColor(_passwordStrength),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _passwordStrength,
                backgroundColor: Colors.grey[300],
                color: getPasswordStrengthColor(_passwordStrength),
                minHeight: 8,
              ),
              const SizedBox(height: 24),
              ShakeWidget(
                key: _confirmPasswordShakeKey,
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'You need to confirm your password!';
                    }
                    if (value != _passwordController.text) {
                      _confirmPasswordController.text = '';
                      return 'Make sure both passwords match!';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text('Select a profile picture:'),
              const SizedBox(height: 8),
              Row (
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedimage = 'assets/profile1.jpg';
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: selectedimage == 'assets/profile1.jpg'
                            ? Border.all(color: Colors.blue, width: 4)
                            : null,
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/profile1.jpg'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedimage = 'assets/profile2.png';
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: selectedimage == 'assets/profile2.png'
                            ? Border.all(color: Colors.blue, width: 4)
                            : null,
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/profile2.png'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedimage = 'assets/profile3.jpg';
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: selectedimage == 'assets/profile3.jpg'
                            ? Border.all(color: Colors.blue, width: 4)
                            : null,
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/profile3.jpg'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),


              // Sign Up Button
              ElevatedButton(
                onPressed: () {
                  // Check each field individually and trigger shake for invalid ones
                  bool hasErrors = false;
                  
                  if (_nameController.text.isEmpty) {
                    _nameShakeKey.currentState?.shake();
                    hasErrors = true;
                  }
                  
                  if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
                    _emailShakeKey.currentState?.shake();
                    hasErrors = true;
                  }
                  
                  // Date of birth is optional - no validation needed
                  
                  if (_passwordController.text.isEmpty || _passwordController.text.length < 6) {
                    _passwordShakeKey.currentState?.shake();
                    hasErrors = true;
                  }
                  
                  if (_confirmPasswordController.text.isEmpty || 
                      _confirmPasswordController.text != _passwordController.text) {
                    _confirmPasswordShakeKey.currentState?.shake();
                    hasErrors = true;
                  }
                  
                  // Only proceed if no errors and form validates
                  if (!hasErrors && _formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Welcome! Account created successfully.'),
                        backgroundColor: Colors.green,
                        
                      ),
                    );
                    if (DateTime.now().hour < 12) {
                      earlybird = true;
                    }
                    if (_dobController.text.isNotEmpty) {
                      profilecompleter = true;
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SuccessScreen()),
                    );
                  } else {
                    // Show validation errors
                    _formKey.currentState!.validate();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
        ),
    )
    );
  }
}

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Begin your Signup Adventure!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                );
              },
              child: Text('Go to Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
