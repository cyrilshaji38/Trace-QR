![BFH Banner](https://trello-attachments.s3.amazonaws.com/542e9c6316504d5797afbfb9/542e9c6316504d5797afbfc1/39dee8d993841943b5723510ce663233/Frame_19.png)
# Trace
Welcome to Trace! This app helps you to avoid having to write your details into a registry at every store you go to during this pandemic. Just scan the merchant's QR Code and you will have a digital record of the shop you visited. If you are a merchant you will have a digital copy of all the customers that have scanned your QR Code.
## Team members
1. Cyril Shaji [https://github.com/cyrilshaji38]
2. Nikita Mathew [https://github.com/nikitamathewk]
## Team Id
BFH/recapacKUJt07GOg9/2021
## Link to product walkthrough
[https://www.youtube.com/watch?v=RdX63MQwr68&ab_channel=CyrilShaji]
## How it Works ?
1. You can register an account either as a customer or a merchant. 
2. As a merchant you can generate a QR code and display it to your customers.
3. As a customer you can scan a merchant's QR code whenever you enter their shop. As soon as you scan a QR code your details are sent to the merchants account and at the same time your are registered as a customer of that shop.
## Libraries used
qr_code_scanner: ^0.4.0

pretty_qr_code: ^2.0.1

image_picker: ^0.7.5+2

firebase_core: ^1.2.0

firebase_auth: ^1.2.0

cloud_firestore: ^2.2.0

firebase_storage: ^8.1.0
## How to configure
1. Setup Flutter: https://flutter.dev/docs/get-started/install

2. Import our project

3. Setup Firebase for the app: https://console.firebase.google.com.

4. Go to the Firebase Console for your new instance. Click "Authentication" in the left-hand menu. Click the "sign-in method" tab. Click "Email/Password" and enable it.
Go to the Firebase Console. Click "Firestore Database" in the left-hand menu. Click the "Create Database" button. It will prompt you to set up, rules, choose test mode, for now.
On the next screen select any of the locations you prefer. In the Firebase console, in the settings of your Android app, add your SHA-1 key by clicking "Add Fingerprint". Download google-services.json and place google-services.json into /android/app/.
## How to Run
1. Download the apk: https://drive.google.com/file/d/1eTzkzzIH7Ov0ocPLptZSWcH_wC1VWWcf/view?usp=sharing
2. Install it on an android phone.
3. Enjoy
