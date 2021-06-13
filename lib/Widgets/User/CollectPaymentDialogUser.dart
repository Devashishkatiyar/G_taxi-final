import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:trackingapp/Widgets/User/GlobalVariables.dart';
import 'package:trackingapp/Widgets/User/SnackBar.dart';
import 'package:trackingapp/Widgets/User/TaxiButton.dart';
import 'package:trackingapp/brand_colors.dart';

class CollectPaymentUser extends StatefulWidget {

  final int fares;

  CollectPaymentUser({ this.fares});

  @override
  _CollectPaymentUserState createState() => _CollectPaymentUserState();
}

class _CollectPaymentUserState extends State<CollectPaymentUser> {
  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),

            Text('PAYMENT'),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),

            Divider(
              height: 2,
              thickness: 1.5,
              indent: 10,
              endIndent: 10,
              color: BrandColors.colorLightGrayFair,
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),

            Text("\u20B9 ${widget.fares}", style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 50),),

            SizedBox(height: 16,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Amount above is the total fares to be charged to the rider', textAlign: TextAlign.center,),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),

            Container(
              width: 230,
              child: TaxiButton(
                title: 'PAY',
                bgColor: BrandColors.colorGreen,
                onPressed: (){
                  openCheckout();
                },
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
          ],
        ),
      ),
    );
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': widget.fares.toInt()*100,
      "currency": "INR",
      'name': 'G-TAXI',
      'description': 'Total Ride Expense',
      'prefill': {'contact': '${currentUserInfo.phoneNumber}', 'email': '${currentUserInfo.email}','name': '${currentUserInfo.name}',},
      'external': {
        'wallets': ['paytm']
      },
      "theme": {
        "color": "#40CF89"
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    rootScaffoldMessengerKey.currentState.showSnackBar(
        showSnackBar("Payment is Successful", context));
    Navigator.pop(context,"close");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    rootScaffoldMessengerKey.currentState.showSnackBar(
        showSnackBar("ERROR: " + response.code.toString() + " - " + response.message, context));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    rootScaffoldMessengerKey.currentState.showSnackBar(
        showSnackBar("EXTERNAL_WALLET: " + response.walletName, context));
  }
}