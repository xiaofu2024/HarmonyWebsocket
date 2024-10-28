https://developer.huawei.com/consumer/en/doc/harmonyos-guides/ide-publish-app-V5


https://developer.huawei.com/consumer/en/doc/harmonyos-guides-V2/creating_har_api9-0000001518082393-V2


https://ohpm.openharmony.cn/#/cn/home

Import the Issued Certificate: If you receive a .cer file, convert it into a .p7b format using the following command:
openssl crl2pkcs7 -nocrl -certfile mycert.cer -out debug_hos.p7b

Import the Certificate to the Keystore: Import the .p7b file into your keystore:
keytool -importcert -trustcacerts -alias myKeyAlias -file debug_hos.p7b -keystore mykeystore.jks