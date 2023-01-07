import 'package:flowerbasket/colors/colorsconf.dart';
import 'package:flowerbasket/pages/userpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';

import 'package:get/get.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import '../client/client.dart';
import '../helper/snackmess.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ListTile(
          title: Text('Payment'),
          subtitle: Text('Click to choose address'),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        toolbarHeight: Get.height * 0.1,
        backgroundColor: MyColors.tertiary,
      ),
      body: FutureBuilder(
        future: sendGet("/user/getaddresses"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.statusCode == 200) {
              var addresses = parseAddressData(snapshot.data!.bodyBytes);
              if (addresses.addresses.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No address found \n first add address"),
                      SizedBox(
                        height: Get.height * 0.05,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Get.toNamed("/useraddaddress");
                          },
                          child: const Text("Add Address"))
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: addresses.addresses.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: (() {
                        Get.to(PaymentConfirmPage(
                          addressId: addresses.addresses[index].addressId,
                        ));
                      }),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 10,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.location_city),
                                    title:
                                        Text(addresses.addresses[index].city),
                                    subtitle: const Text("city"),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.location_on),
                                    title:
                                        Text(addresses.addresses[index].state),
                                    subtitle: const Text("state"),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.roundabout_left),
                                    title:
                                        Text(addresses.addresses[index].street),
                                    subtitle: const Text("street"),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.numbers),
                                    title: Text(
                                        addresses.addresses[index].zipCode),
                                    subtitle: const Text("zip code"),
                                  ),
                                  ListTile(
                                    leading:
                                        const Icon(Icons.difference_outlined),
                                    title:
                                        Text(addresses.addresses[index].detail),
                                    subtitle: const Text("detail"),
                                  ),
                                ],
                              ))));
                },
              );
            } else {
              return const Center(
                child: Text("Error"),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class PaymentConfirmPage extends StatefulWidget {
  const PaymentConfirmPage({
    Key? key,
    required this.addressId,
  }) : super(key: key);

  final int addressId;

  @override
  State<PaymentConfirmPage> createState() => _PaymentConfirmPageState();
}

class _PaymentConfirmPageState extends State<PaymentConfirmPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: const Color.fromARGB(255, 21, 1, 49).withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Payment'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        toolbarHeight: Get.height * 0.1,
        backgroundColor: MyColors.tertiary,
        actions: [
          //confirm
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(
                Icons.check,
                size: 30,
              ),
              tooltip: 'Confirm',
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  var result = await sendGet(
                      "/user/buycart?adressId=${widget.addressId}");
                  var message = parseMess(result.bodyBytes);
                  if (result.statusCode == 200) {
                    Get.offAll(const Home(), arguments: 3);
                    SnackMess("Success", message.message, Colors.green,
                        SnackPosition.TOP, Icons.check);
                  } else {
                    SnackMess("Error", message.message, MyColors.red,
                        SnackPosition.TOP, Icons.error);
                  }
                } else {
                  SnackMess("Error", "Please fill all fields", MyColors.red,
                      SnackPosition.TOP, Icons.error);
                }
              },
            ),
          ),
        ],
      ),
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          CreditCardWidget(
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            showBackView: isCvvFocused,
            obscureCardNumber: true,
            obscureCardCvv: true,
            isHolderNameVisible: true,
            cardBgColor: MyColors.primary,
            isSwipeGestureEnabled: true,
            onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: const Color.fromARGB(255, 236, 226, 253),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Card Details',
                  style: TextStyle(
                    color: MyColors.bold,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CreditCardForm(
                  formKey: formKey,
                  obscureCvv: true,
                  obscureNumber: true,
                  cardNumber: cardNumber,
                  cvvCode: cvvCode,
                  isHolderNameVisible: true,
                  isCardNumberVisible: true,
                  isExpiryDateVisible: true,
                  cardHolderName: cardHolderName,
                  expiryDate: expiryDate,
                  themeColor: MyColors.primary,
                  textColor: MyColors.bold,
                  cardNumberDecoration: InputDecoration(
                    labelText: 'Number',
                    hintText: 'XXXX XXXX XXXX XXXX',
                    hintStyle: const TextStyle(color: MyColors.bold),
                    labelStyle: const TextStyle(color: MyColors.bold),
                    focusedBorder: border,
                    enabledBorder: border,
                  ),
                  expiryDateDecoration: InputDecoration(
                    hintStyle: const TextStyle(color: MyColors.bold),
                    labelStyle: const TextStyle(color: MyColors.bold),
                    focusedBorder: border,
                    enabledBorder: border,
                    labelText: 'Expired Date',
                    hintText: 'XX/XX',
                  ),
                  cvvCodeDecoration: InputDecoration(
                    hintStyle: const TextStyle(color: MyColors.bold),
                    labelStyle: const TextStyle(color: MyColors.bold),
                    focusedBorder: border,
                    enabledBorder: border,
                    labelText: 'CVV',
                    hintText: 'XXX',
                  ),
                  cardHolderDecoration: InputDecoration(
                    hintStyle: const TextStyle(color: MyColors.bold),
                    labelStyle: const TextStyle(color: MyColors.bold),
                    focusedBorder: border,
                    enabledBorder: border,
                    labelText: 'Card Holder',
                  ),
                  onCreditCardModelChange: onCreditCardModelChange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
