import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StripeTransactionResponse{
  String message;
  bool success;
    StripeTransactionResponse({this.message,this.success});
}
//pk_test_51HmhdBCsrbtRaubZuRaTZA48xHnW37WyTSIWVdDL84UNFQWTkkmBT73ubJh8GYVeqmNOvT8BJtCVMWfxi01vHyY400Cb9Gotxs
//sk_test_51HmhdBCsrbtRaubZXXsN46Zokli967a5K9R3U7VqA7qMBC5nIP8UPsNzS2wBxFbgV7w2RzAeb8Y4XULcr7RhdTBs00WzkpzUzu
//pk_live_51HmhdBCsrbtRaubZDLDUKLk3wB3OnYcHQckBJjsCG7tqbuQ7sUC4XeEXyW67uR5yok1N0KFucO5FMmenVIpLArca00wSZZpzbQ
//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

class StripeService{
  static String apiBase='https://api.stripe.com/v1';
  static String paymentApiUrl='${StripeService.apiBase}/payment_intents';
  static String secret='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';
  static Map<String,String> headers={
    'Authorization':'Bearer ${StripeService.secret}',
    'Content-Type':'application/x-www-form-urlencoded'
  };

  static init(){
    StripePayment.setOptions(
        StripeOptions(
            publishableKey: "pk_live_51HmhdBCsrbtRaubZDLDUKLk3wB3OnYcHQckBJjsCG7tqbuQ7sUC4XeEXyW67uR5yok1N0KFucO5FMmenVIpLArca00wSZZpzbQ",
            merchantId: "test",
            androidPayMode: 'test'));

  }

  static Future<StripeTransactionResponse> payWithExistingCard({String amount,String currency, CreditCard card,}) async {
    StripeTransactionResponse response;
    try{
      await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card)
      ).whenComplete(() => null).then((paymentMethod) async {
        await StripeService.createPaymentIntent(amount, currency).whenComplete(() => null).then((value) async {
          await StripePayment.confirmPaymentIntent(
              PaymentIntent(
                  clientSecret: value['client_secret'],
                  paymentMethodId: paymentMethod.id,
              )
          ).whenComplete(() => null).then((value) {
            if (value.status=='succeeded'){
              response= StripeTransactionResponse(
                  message: 'Transaction effectuée avec succés',
                  success: true
              );
            }
            else{
              print(value.status+'////////////////////////');
              response= StripeTransactionResponse(
                  message: 'La transaction à échoué',
                  success: false
              );
            }
          });
        });
      });




    }on PlatformException catch (err){
      response=StripeTransactionResponse(
        message: err.message,
        success: false
      );
    }
    catch(err){
      response= StripeTransactionResponse(
        message: err.toString(),
        success: false
      );
    }
    return response;

  }
  static Future<Map<String,dynamic>> createPaymentIntent(String amount,String currency) async {
    try{
      Map<String,dynamic> body={
        'amount':amount,
        'currency':currency,
        'payment_method_types[]':'card'
      };
     var response=await http.post(
      StripeService.paymentApiUrl,
       body: body,
       headers: StripeService.headers
     );

     return jsonDecode(response.body);
    }catch(err){
      print('error chargin user : ${err.toString()}');
    }

  }

}