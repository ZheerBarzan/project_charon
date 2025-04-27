import 'package:appwrite/appwrite.dart';

class Appwrite {
  Client client = Client();

  Appwrite() {
    client
        .setEndpoint('https://fra.cloud.appwrite.io/v1')
        .setProject('680df948001ab4474ff0')
        .setSelfSigned(
          status: true,
        ); // For self signed certificates, only use for development;
  }
}
