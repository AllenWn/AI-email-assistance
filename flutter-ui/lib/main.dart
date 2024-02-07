import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String baseUrl = "http://35.166.209.129:8080";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ...
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        // 根据settings.name来判断应该创建哪个页面的路由
        switch (settings.name) {
          case '/':
            builder = (BuildContext context) => IndexPage();
            break;
          case '/login':
            builder = (BuildContext context) => LoginPage();
            break;
          case '/register':
            builder = (BuildContext context) => RegistrationPage();
            break;
          case '/main':
            builder = (BuildContext context) => MainPage();
            break;
          case '/compose_mail':
            builder = (BuildContext context) => ComposeMailPage();
            break;
          case '/generate_graph':
            builder = (BuildContext context) => GenerateGraphPage();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        // 使用PageRouteBuilder而不是MaterialPageRoute可以禁用侧滑返回
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child; // 不需要任何过渡动画
          },
          settings: settings, // 确保传递设置信息
        );
      },
    );
  }
}

/*#################### Index Page ####################*/

class IndexPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<IndexPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 138, 249, 192),
              Color.fromARGB(255, 96, 141, 245)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 200), // LOGO 下方的间隔
              //child: Image.asset(
              //'assets/logo_placeholder.png', // 占位符LOGO的路径
              //height: 150, // 根据实际LOGO调整大小
              //),
              child: Text(
                "LOGO",
                style: TextStyle(
                    fontSize: 50,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 120), // 根据实际情况调整
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled:
                        true, // Set this to true to enable full screen modal
                    barrierColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return FractionallySizedBox(
                        heightFactor:
                            0.67, // The fraction of the screen height you want the sheet to cover
                        child: LoginPage(), // Your login page content
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 14, 86, 168),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 90),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: Text('登录',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    )),
              ),
            ),
            SizedBox(height: 40), // 根据实际情况调整
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled:
                        true, // Set this to true to enable full screen modal
                    barrierColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return FractionallySizedBox(
                        heightFactor:
                            0.67, // The fraction of the screen height you want the sheet to cover
                        child: RegistrationPage(), // Your login page content
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  //side: BorderSide(color: Colors.white),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 90),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: Text('注册',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 14, 86, 168),
                        fontSize: 25)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*######################## Login Page #########################*/

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _rememberMe = false;

  String? _validateEmail(String value) {
    final emailPattern = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    if (!emailPattern.hasMatch(value)) {
      return '邮箱格式不正确';
    }
    return null;
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 167, 221, 239),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60.0),
          topRight: Radius.circular(60.0),
        ),
      ),
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Take up only as much space as needed
          children: <Widget>[
            SizedBox(height: 24),
            Text(
              '登录',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800], // Adjust the color to match the design
              ),
            ),
            SizedBox(height: 35),
            _buildTextField(
                controller: usernameController,
                label: '用户名',
                validator: (value) {
                  if (value!.isEmpty) {
                    return '请输入邮箱';
                  }
                  return _validateEmail(value);
                }),
            SizedBox(height: 30),
            _buildTextField(
                controller: passwordController,
                label: '密码',
                isPassword: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '请输入密码';
                  }
                  return null;
                }),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5.0), // Adjust the radius to make it round
                    ),
                  ),
                  Text("记住我"),
                ],
              ),
            ),
            SizedBox(height: 20),
            _buildLoginButton(context),
            SizedBox(height: 20),
            Text(
              '忘记密码?',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(
                    255, 14, 56, 104), // Adjust the color to match the design
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return SizedBox(
      width: 350,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 128, 162, 217),
            fontSize: 20,
          ),
          fillColor: Colors.blue[50],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 133, 179, 230)!,
              width: 2.0,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 24.0,
          ),
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        obscureText: isPassword,
        validator: validator,
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          // Handle login logic here
          final username = usernameController.text;
          final password = passwordController.text;
          // Perform login validation
          // If login is successful, navigate to the main page

          final response = await http.post(
            Uri.parse('$baseUrl/user/login'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'username': username,
              'password': password,
            }),
          );

          if (response.statusCode == 200) {
            // Login successful
            Navigator.pushReplacementNamed(context, '/main');
            print('Login successful');
          } else {
            // Login failed

            print('Login failed: ${response.body}');
          }

          // Check if remember me is selected
          if (_rememberMe) {
            // Save login information to local storage
            // You can use shared_preferences or other local storage libraries
          }
        }
      },
      style: ElevatedButton.styleFrom(
        primary: const Color.fromARGB(
            255, 14, 86, 168), // Adjust the color to match the design
        minimumSize: Size(MediaQuery.of(context).size.width * 0.6,
            70), // Make the button wide
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        '登录',
        style: TextStyle(fontSize: 30, color: Colors.white),
      ),
    );
  }
}

/*###################### Registration Page ######################*/

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? _validatePasswordMatch(String value) {
    if (value != passwordController.text) {
      return '密码不匹配';
    }
    return null;
  }

  String? _validateEmail(String value) {
    final emailPattern = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    if (!emailPattern.hasMatch(value)) {
      return '邮箱格式错误';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return '请输入密码';
    }

    if (value.length < 8) {
      return '密码长度必须大于8位';
    }

    final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
    final hasDigit = RegExp(r'\d').hasMatch(value);
    final hasSpecialChar = RegExp(r'[!@#\$%^&*(),.?":{}|_<>]').hasMatch(value);

    if (!(hasUppercase && hasLowercase && hasDigit && hasSpecialChar)) {
      return '密码必须包含大写字母、小写字母、数字和特殊字符';
    }

    if (value == emailController.text) {
      return '密码不可以与邮箱号一样';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 167, 221, 239),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60.0),
          topRight: Radius.circular(60.0),
        ),
      ),
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '注册',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800], // Adjust the color to match the design
              ),
            ),
            SizedBox(height: 40),
            _buildTextField(
                controller: emailController,
                labelText: '邮箱',
                hintText: '请输入您的邮箱',
                validator: (value) {
                  if (value!.isEmpty) {
                    return '请输入邮箱';
                  }
                  return _validateEmail(value);
                }),
            SizedBox(height: 30),
            _buildTextField(
                controller: passwordController,
                labelText: '密码',
                hintText: '请输入您的密码',
                isPassword: true,
                validator: (value) {
                  return _validatePassword(value!);
                }),
            SizedBox(height: 30),
            _buildTextField(
                controller: confirmPasswordController,
                labelText: '确认密码',
                hintText: '请再次输入您的密码',
                isPassword: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '请再次输入密码';
                  }
                  return _validatePasswordMatch(value);
                }),
            SizedBox(height: 40),
            _buildRegistrationButton(context)
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return SizedBox(
      width: 350,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color.fromARGB(133, 23, 35, 80),
            fontSize: 16,
          ),
          labelStyle: TextStyle(
            color: Color.fromARGB(133, 21, 30, 67),
            fontSize: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Color.fromARGB(255, 39, 69, 95)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Color.fromARGB(255, 39, 69, 95)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Color.fromARGB(255, 39, 69, 95)),
          ),
          filled: true,
          fillColor: Color.fromARGB(228, 255, 255, 255),
        ),
        obscureText: isPassword,
        style: TextStyle(color: Color.fromARGB(255, 16, 59, 106), fontSize: 18),
        validator: validator, // Use the provided validator function
      ),
    );
  }

  Widget _buildRegistrationButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          // 处理注册逻辑
          final email = emailController.text;
          final password = passwordController.text;
          //final confirmPassword = confirmPasswordController.text;
          final registrationStatus;
          // 进行注册验证
          // 模拟注册成功
          // 这里可以添加实际的注册逻辑
          // 如果注册成功，显示SnackBar
          final response = await http.post(
            Uri.parse('$baseUrl/user/register'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'username': email,
              'password': password,
            }),
          );
          if (response.statusCode == 200) {
            // Registration successful, handle accordingly (e.g., show a success message)
            registrationStatus = true;
            print('Registration successful');
          } else {
            // Registration failed, handle accordingly (e.g., show an error message)
            registrationStatus = false;
            print('Registration failed: ${response.body}');
          }

          if (registrationStatus) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('注册成功！请前往登录'),
              ),
            );
            // Navigate back to the login page
            Navigator.pop(context);
          }
        }
      },
      style: ElevatedButton.styleFrom(
        primary: const Color.fromARGB(
            255, 14, 86, 168), // Adjust the color to match the design
        minimumSize: Size(MediaQuery.of(context).size.width * 0.6,
            70), // Make the button wide
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        '注册',
        style: TextStyle(fontSize: 30, color: Colors.white),
      ),
    );
  }
}

/*######################### Main Page ##########################*/

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            SizedBox(width: 10),
            Text('欢迎回来, 用户名！', style: TextStyle(color: Colors.black)),
          ],
        ),
        actions: [
          IconButton(
            //style: ,
            icon: Icon(
              Icons.notifications,
              size: 30,
            ),
            color: Colors.black,
            onPressed: () {
              // TODO: Add notification page navigation logic here
            },
          ),
        ],
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 35,
            ),
            label: '主页',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
              size: 35,
            ),
            label: '记录',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 35,
            ),
            label: '账号',
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          HomePage(), // Assuming this is your home page
          RecordPage(), // New page for "记录"
          UserPage(), // New page for "用户"
        ],
      ),
    );
  }
}

/*######################### Navigation Pages ##########################*/

class RecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '记录页面',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class UserPage extends StatelessWidget {
  void _logout(BuildContext context) {
    // Perform logout logic here
    // For example, you can clear user authentication tokens or reset user state

    // Navigate back to the login page
    Navigator.pushNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '用户账号页面',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            _buildLogoutButton()
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Builder(
      builder: (BuildContext context) {
        return ElevatedButton(
          onPressed: () {
            _logout(context);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
                horizontal: 80, vertical: 15), // Adjust button size
            backgroundColor: Colors.teal,
          ),
          child: Text(
            '登出',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold), // Adjust text size
          ),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildFeatureButton(
              icon: Icons.email,
              text: '邮件助手',
              onTap: () {
                Navigator.pushNamed(context, '/compose_mail');
              },
            ),
            SizedBox(height: 20), // Add spacing between buttons
            _buildFeatureButton(
              icon: Icons.image,
              text: '图像生成',
              onTap: () {
                Navigator.pushNamed(context, '/generate_graph');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 40.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 64, 255, 169),
              const Color.fromARGB(255, 33, 135, 243),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 40.0, color: Colors.white),
            SizedBox(width: 20.0),
            Text(
              text,
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*######################### Functionality Pages ##########################*/

class ComposeMailPage extends StatefulWidget {
  @override
  _ComposeMailPageState createState() => _ComposeMailPageState();
}

class _ComposeMailPageState extends State<ComposeMailPage> {
  final TextEditingController _senderController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();
  String _tone = '正式';
  final TextEditingController _emailContentController = TextEditingController();
  String? generatedEmailContent;

  final Color _borderEnabledColor = Colors.blueGrey;
  final Color _borderFocusedColor = Colors.teal;

  bool _loading = false;

  void _swapText() {
    setState(() {
      String temp = _senderController.text;
      _senderController.text = _recipientController.text;
      _recipientController.text = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('邮件助手', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: _buildTextField(
                    controller: _senderController,
                    labelText: '发件人',
                    hintText: '请输入发件人姓名',
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.swap_horiz),
                  onPressed: _swapText,
                ),
                Expanded(
                  child: _buildTextField(
                    controller: _recipientController,
                    labelText: '收件人',
                    hintText: '请输入收件人姓名',
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            _buildTextField(
              controller: _emailContentController,
              labelText: '邮件内容',
              hintText: '请输入您的邮件内容',
              maxLines: 6,
            ),
            SizedBox(height: 50),
            _buildDropdownButtonFormField(
              value: _tone,
              labelText: '语气与态度',
              items: ['正式', '非正式'],
              onChanged: (String? newValue) {
                setState(() {
                  _tone = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            _buildButton(
              text: '生成邮件',
              onPressed: () async {
                await _generateEmail();
              },
            ),
            SizedBox(height: 20), // Added some spacing
            if (_loading)
              CircularProgressIndicator()
            else if (generatedEmailContent != null)
              Expanded(
                child: SingleChildScrollView(
                  child: EmailContentBox(emailContent: generatedEmailContent!),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateEmail() async {
    final prompt = _emailContentController.text;
    final sender = _senderController.text;
    final recipient = _recipientController.text;

    setState(() {
      _loading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/email'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_input': prompt,
          'sender': sender,
          'recipient': recipient,
          'tone': _tone
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          generatedEmailContent = jsonResponse;
          _loading = false;
        });
      } else {
        print('Error: ${response.statusCode}');
        setState(() {
          _loading = false;
        });
        // Handle error - Display an error message or handle it as needed
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _loading = false;
      });
      // Handle error - Display an error message or handle it as needed
    }
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String labelText,
      required String hintText,
      int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: _borderEnabledColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _borderEnabledColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _borderFocusedColor),
        ),
        fillColor: Color.fromARGB(255, 251, 251, 251),
        filled: true,
      ),
    );
  }

  Widget _buildDropdownButtonFormField(
      {required String value,
      required String labelText,
      required List<String> items,
      required void Function(String?) onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: _borderEnabledColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _borderEnabledColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _borderFocusedColor),
        ),
      ),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.teal,
        onPrimary: Colors.white,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class EmailContentBox extends StatelessWidget {
  final String emailContent;

  EmailContentBox({required this.emailContent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SelectableText(
        emailContent,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class GenerateGraphPage extends StatefulWidget {
  @override
  _GenerateGraphPageState createState() => _GenerateGraphPageState();
}

class _GenerateGraphPageState extends State<GenerateGraphPage> {
  final TextEditingController _inputController = TextEditingController();
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('图像生成', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _inputController,
              maxLines: null,
              expands: false,
              decoration: InputDecoration(
                hintText: '在此输入...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _generateImage();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                '生成',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 30),
            if (imageUrl != null) DalleImageBox(imageUrl: imageUrl!),
          ],
        ),
      ),
    );
  }

  Future<void> _generateImage() async {
    final prompt = _inputController.text;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/dalle'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'prompt': prompt,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          imageUrl = jsonResponse;
        });
      } else {
        print('Error: ${response.statusCode}');
        // Handle error - Display an error message or handle it as needed
      }
    } catch (e) {
      print('Error: $e');
      // Handle error - Display an error message or handle it as needed
    }
  }
}

class DalleImageBox extends StatelessWidget {
  final String imageUrl;

  DalleImageBox({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          }
        },
      ),
    );
  }
}
