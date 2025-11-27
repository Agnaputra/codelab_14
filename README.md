# codelab_14

# Practical 1: Creating a Mock API service

### Step 1
1. Sign up for the Mock Lab service at https://app.wiremock.cloud/ and register on the site, create your username and password.

![alt text](pizza_agna/images/lab1/1.png)

### Step 2
2. Log in to the service, go to "Example Mock API," and click on the Stubs section of the example API. Then, click on the first entry—Get a JSON resource. You should see a screen similar to the following:

![alt text](pizza_agna/images/lab1/2.png)

### Step 3
Click the New button. For the Name, type Pizza List, leave GET as the verb, and in the text box next to the GET verb, type /pizzalist. Then, in the Response section, for status 200, select JSON as the format and paste the JSON content available at https://bit.ly/pizzalist .

![alt text](pizza_agna/images/lab1/3.png)


### Step 4
Click the Save button at the bottom of the page to save the stub. This completes the setup for the mock backend service.

![alt text](pizza_agna/images/lab1/4.png)

### Step 5
Back in your Flutter project, add the http dependency by typing in your Terminal:
flutter pub add http

![alt text](pizza_agna/images/lab1/5.png)

### Step 6
In the lib folder in your project, add a new file named httphelper.dart.
![alt text](pizza_agna/images/lab1/6.png)


### Step 7
In the httphelper.dart file, add the following code:
```dart:
import 'dart:io'; 
import 'package:http/http.dart' as http; 
import 'dart:convert'; 
import 'pizza.dart'; 

class HttpHelper {
  final String authority = '02z2g.mocklab.io';
  final String path = 'pizzalist';
  Future<List<Pizza>> getPizzaList() async {
    final Uri url = Uri.https(authority, path);
    final http.Response result = await http.get(url);
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      //provide a type argument to the map method to avoid type 
      //error
      List<Pizza> pizzas =
          jsonResponse.map<Pizza>((i) => 
            Pizza.fromJson(i)).toList();
      return pizzas;
    } else {
      return [];
    }
  }
}
```

### Step 8
In the main.dart file, in the _MyHomePageState class, add a method named callPizzas. This returns a Future of a List of Pizza objects by calling the getPizzaList method of the HttpHelper class, as follows:
```dart:
Future<List<Pizza>> callPizzas() async {
  HttpHelper helper = HttpHelper(); 
  List<Pizza> pizzas = await helper.getPizzaList(); 
  return pizzas; 
} 
```

### Step 9
In the build method of the _MyHomePageState class, in the Scaffold body, add a FutureBuilder that builds a ListView from a ListTile widget containing Pizza objects:
```dart:
Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(title: const Text('JSON')),
      body: FutureBuilder(
          future: callPizzas(),
          builder: (BuildContext context, AsyncSnapshot<List<Pizza>> 
snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
            return ListView.builder(
                itemCount: (snapshot.data == null) ? 0 : snapshot.
data!.length,
                itemBuilder: (BuildContext context, int position) {
                  return ListTile(
                    title: Text(snapshot.data![position].pizzaName),
                    subtitle: Text(snapshot.data![position].
description +
                        ' - € ' +
                        snapshot.data![position].price.toString()),
                  );
                });
          }),
    );  
}
```

### Step 10
Run the application. You should see a screen similar to the following:


The image is a screenshot of a list of items fetched over HTTP, showing a ListView with the pizza name and its description.

Question 1
Add your nickname to titlethe app as an identity for your work.
Change the application theme color according to your preference.
Capture the results of your application, then enter it into the report in the README and commit the results of the answer to Question 1 with the message "W14: Answer to Question 1"
We currently only have one method that uses the HttpHelper class. As our application grows, we may need to call HttpHelper multiple times in different parts of the application, and it would be a waste of resources to create multiple instances of the class each time we need to use a method from that class.

One way to avoid this is to use a factory constructor and the singleton pattern: this ensures you only instantiate a class once. This is useful whenever only one object is needed in your application and when you need to access resources you want to share across applications.

In the file httphelper.dart, add the following code to the class HttpHelper, just below the declaration:

static final HttpHelper _httpHelper = HttpHelper._internal();
HttpHelper._internal();
factory HttpHelper() {
    return _httpHelper;
}
There are several patterns in Dart and Flutter that allow you to share services and business logic across your apps, and the singleton pattern is just one of them. Other options include Dependency Injection, Inherited Widgets, and Provider and Service Locators. There's an interesting article about the different options available in Flutter at http://bit.ly/flutter_DI