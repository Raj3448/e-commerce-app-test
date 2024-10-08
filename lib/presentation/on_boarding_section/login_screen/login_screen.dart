import 'package:ecommerce_seller/presentation/on_boarding_section/login_screen/components/login_with_email.dart';
import 'package:ecommerce_seller/presentation/on_boarding_section/login_screen/components/login_with_phone.dart';
import 'package:ecommerce_seller/presentation/on_boarding_section/login_screen/controller/login_controller.dart';
import 'package:ecommerce_seller/presentation/on_boarding_section/login_screen/store/login_store.dart';
import 'package:ecommerce_seller/presentation/on_boarding_section/otp/otp_screen.dart';
import 'package:ecommerce_seller/utilz/colors.dart';
import 'package:ecommerce_seller/utilz/components/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobx/mobx.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  PageController pageController = PageController();

  final login = Get.put(LoginController());
  final store = GetIt.I<LoginStore>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    reaction((_) => store.authFailure, (authFailure) {
      if (store.authFailure != null && mounted) {
        store.authFailure?.fold(
          (l) {
            l.maybeWhen(
              invalidEmail: () {
                Get.snackbar(
                  'Invalid Email',
                  'Please enter a valid email address!',
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              invalidPassword: () {
                Get.snackbar(
                  'Invalid password',
                  '',
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              userNotFound: () {
                Get.snackbar(
                  'User not found',
                  '',
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              orElse: () {
                Get.snackbar(
                  'Something went wrong',
                  '',
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            );
          },
          (r) {
            Get.to(() => OtpScreen(
                  loginResponseModel: r,
                ));
          },
        );
        store.authFailure = null;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    store.authFailure = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Stack(
        children: [
          Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: Adaptive.h(5),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),
                      Text(
                        'Back',
                        style: GoogleFonts.poppins(
                            fontSize: 14.px, color: buttonColor),
                      ),
                      // SizedBox(width: Adaptive.w(5),),
                      Text(
                        'Sign up',
                        style: GoogleFonts.poppins(
                            fontSize: 14.px, color: buttonColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Adaptive.h(4),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Login using Mobile\nNumber or Email',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 30.px),
                    ),
                  ),
                  SizedBox(
                    height: Adaptive.h(2),
                  ),
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 1.5.h),
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    decoration: BoxDecoration(
                      color: Color(0xffE6E6E6),
                      borderRadius: BorderRadius.circular(Adaptive.w(8)),
                    ),
                    child: Obx(() {
                      return Row(
                        children: [
                          login.selectedValue.value == 'Login'
                              ? GestureDetector(
                                  onTap: () {
                                    //  login.changingSelectedOption('login');
                                    pageController.previousPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.linear);
                                  },
                                  child: Material(
                                    elevation: 5,
                                    borderRadius:
                                        BorderRadius.circular(Adaptive.w(8)),
                                    child: Container(
                                      width: Adaptive.w(45),
                                      height: Adaptive.h(6),
                                      // padding: EdgeInsets.only(left: 5.w,right: 5.w,top: 1.h,bottom: 1.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Adaptive.w(12)),
                                        color: buttonColor,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Mobile Number',
                                          style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    login.changingSelectedOption('Login');
                                    pageController.previousPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.linear);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 5.w,
                                        right: 5.w,
                                        top: 1.h,
                                        bottom: 1.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.transparent,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Mobile Number',
                                        style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                          Spacer(),
                          login.selectedValue.value == 'Email'
                              ? GestureDetector(
                                  onTap: () {
                                    login.changingSelectedOption('Email');
                                    pageController.nextPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.linear);
                                  },
                                  child: Container(
                                    width: Adaptive.w(45),
                                    height: Adaptive.h(6),
                                    // padding: EdgeInsets.only(left: 5.w,right: 5.w,top: 1.h,bottom: 1.h),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(Adaptive.w(12)),
                                      color: buttonColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Email',
                                        style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    login.changingSelectedOption('Email');
                                    pageController.nextPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.linear);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 12.w,
                                        right: 12.w,
                                        top: 1.h,
                                        bottom: 1.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      // color: Colors.transparent,
                                    ),
                                    child: Center(
                                      child: Text(
                                        ' Email',
                                        style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      );
                    }),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Expanded(
                    child: Container(
                      //  height: Adaptive.h(6),
                      color: Colors.amber,
                      child: PageView(
                        scrollDirection: Axis.horizontal,
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: pageController,
                        children: [
                          LoginScreenWithPhone(),
                          LoginScreenWithEmail(
                            emailController: emailController,
                            passwordController: passwordController,
                          )
                        ],
                        onPageChanged: (value) {
                          print("index:$value");
                          if (value == 0) {
                            // login.changingSelectedOption("login");
                          } else {
                            // login.changingSelectedOption("email");
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (store.isLoading == true)
            Material(color: Colors.transparent, child: const LoadingWidget()),
        ],
      );
    });
  }
}
