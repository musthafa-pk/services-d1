import 'package:doctor_one/res/appUrl.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'Adding Prescription.dart';
import 'All Task page.dart';
import 'Lab Cart.dart';
import 'My bookings.dart';
import 'Packages Page.dart';
import 'LabUrl.dart';

class LabHomePage extends StatefulWidget {
  @override
  State<LabHomePage> createState() => _LabHomePageState();
}
class LabColors {
  static const Color primaryColor = Color.fromRGBO(76, 193, 170, 1.0);
  static const Color lightPrimaryColor1 = Color.fromRGBO(200, 230, 223, 1.0);

  // Change from `const` to `final`
  static final Color extraLightPrimary = primaryColor.withOpacity(0.1); // 10% opacity
}
class _LabHomePageState extends State<LabHomePage> {

  late Future<List<Package>> futurePackages;
  late Future<List<LabPackage>> futureLabs;

  int? _cartItemCount;


  @override
  void initState() {
    super.initState();
    futurePackages = fetchPackages();
    futureLabs = fetchLabs(); // Initialize the futureLabs
    _fetchLocationAndLabs();
  }
  Set<String> _cartItems = {}; // Track which items are in the cart


  final List<Map<String, String>> healthConcerns = [
    {'label': 'Cancer', 'imagePath': 'assets/droneicons/cancer.png'},
    {'label': 'Diabetes', 'imagePath': 'assets/droneicons/diabetes.png'},
    {'label': 'Fever', 'imagePath': 'assets/droneicons/fever.png'},
    {'label': 'Kidney', 'imagePath': 'assets/droneicons/kidney.png'},
    {'label': 'Liver', 'imagePath': 'assets/droneicons/liver.png'},
    {'label': 'Wellness', 'imagePath': 'assets/droneicons/sex-education.png'},
  ];

  String? pincode = 'Pincode';

  Future<void> _getLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          locationName = place.locality ?? "Unknown"; // Fetching city/locality name
          pincode = place.postalCode ?? "N/A"; // Fetching pincode
        });

        print("Updated Location: $locationName, Pincode: $pincode"); // Debugging log
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }


  Future<void> _fetchLocationAndLabs() async {
    await _getLocation(); // Ensure pincode is updated
    await Future.delayed(Duration(seconds: 3));

    if (pincode != null && pincode != 'Pincode') {
      await fetchLabs();
    } else {
      print("Pincode not updated, skipping fetchLabs");
    }
  }


  Future<int> fetchCartCount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final String apiUrl = LabUrl.getCartcountandGetCart;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": int.parse(userID.toString())}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData['success'] == true) {
          return jsonData['data']['tests'].length;
        }
      }
    } catch (e) {
      print("Error fetching cart data: $e");
    }
    return 0;
  }
  Future<void> addToCart(Package package) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final body = json.encode({
      "test_number": package.testNumber,  // ✅ Use dynamic test number
      "userId": int.parse(userID.toString())
    });

    print('Request Body: $body');

    try {
      final response = await http.post(
        Uri.parse(LabUrl.addToCart),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      // ✅ Accept 200 or 201 and check API success flag
      if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
        setState(() {
          package.isInCart = true;
          _cartItems.add(package.testNumber);
          _cartItemCount = _cartItems.length;
        });
      } else {
        throw Exception('API responded with failure: ${data['message']}');
      }
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  Future<void> removeFromCart(Package package) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final response = await http.post(
      Uri.parse(LabUrl.removeFromCart),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"test_number": package.testNumber, "userId": int.parse(userID.toString())}),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      setState(() {
        package.isInCart = false;
        _cartItems.remove(package.testNumber); // ✅ Remove from local cart list
        _cartItemCount = _cartItems.length; // ✅ Update cart count
      });
    } else {
      throw Exception('Failed to remove from cart: ${response.statusCode}');
    }
  }

  Future<List<TestPackage>> fetchTestPackages() async {
    final response = await http.post(
      Uri.parse(LabUrl.getallTests),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"first": true}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['success'] == true) {
        List<dynamic> tests = responseBody['data'];
        return tests.map((json) => TestPackage.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load test packages');
      }
    } else {
      throw Exception('Failed to connect to API');
    }
  }

  Future<void> addToCartTest(TestPackage package) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final response = await http.post(
      Uri.parse(LabUrl.addToCart),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"test_number": package.testNumber, "userId": int.parse(userID.toString())}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        package.isInCart = true;
      });
    }
  }

  Future<void> removeFromCartTest(TestPackage package) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final response = await http.post(
      Uri.parse(LabUrl.removeFromCart),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"test_number": package.testNumber, "userId": int.parse(userID.toString())}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        package.isInCart = false;
      });
    }
  }

  Future<List<LabPackage>> fetchLabs() async {
    print('sss:$pincode');
    final response = await http.post(
      Uri.parse(LabUrl.getnearestLabs),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"pincode": "${676305}"}), // You can update the pincode dynamically
    );
    print('passing....${json.encode({"pincode": "${pincode}"})}');
    print('its ssddd:${response.body}');
    if (response.statusCode == 200) {
      print('its ss:${response.body}');
      Map<String, dynamic> data = json.decode(response.body);

      // Check if the API returned success
      if (data['success'] != true) {
        throw Exception('API returned success: false');
      }

      List<dynamic> labsJson = data['data'];
      return labsJson.map((json) => LabPackage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load labs: ${response.statusCode}');
    }
  }

  Future<List<Package>> fetchPackages() async {
    final response = await http.post(
      Uri.parse(LabUrl.getallPackages),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"first": true}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      // Add success check
      if (data['success'] != true) {
        throw Exception('API returned success: false');
      }

      List<dynamic> packagesJson = data['data'];
      return packagesJson.map((json) => Package.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load packages: ${response.statusCode}');
    }
  }

  String locationName = 'Fetching...';


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPrescriptionScreenLab(),));
        },
        backgroundColor: LabColors.primaryColor, // Use your primary color
        child: Icon(Icons.upload_file, color: Colors.white), // Upload icon with white color
      ),

        body: SafeArea(
          child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 16,right: 16,bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap:_getLocation,
                            child: Image.asset("assets/droneicons/location.png", width: 30, height: 30)),
                        Text(
                          "$locationName,\n$pincode",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<int>(
                    future: fetchCartCount(),
                    builder: (context, snapshot) {
                      int itemCount = snapshot.data ?? 0;
          
                      return Stack(
                        children: [
                          IconButton(
                            icon: Icon(Icons.shopping_cart,color: Colors.black,),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(),));
                            },
                          ),
                          if (itemCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  itemCount.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search Labs',
                  filled: true,
                  fillColor:LabColors.extraLightPrimary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      CategoryItem(imagePath: 'assets/droneicons/booklabtest.png', label: 'Book Lab'),
                      Text('Tests',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)
                    ],
                  ),
                  Column(
                    children: [
                      CategoryItem(imagePath: 'assets/droneicons/popularhealthcheck.png', label: 'Popular Health'),
                      Text('Checks',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)
                    ],
                  ),
                  Column(
                    children: [
                      CategoryItem(imagePath: 'assets/droneicons/xrays&mri.png', label: 'X-Ray, Scan &'),
                      Text('MRI',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)
                    ],
                  ),
                ],
              ),
          
              SizedBox(height: 20),
              // SectionHeader(title: 'Health Concern Packages'),
              InkWell(
                onTap: () {
          
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Health Concern',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                      Text('Packages',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                    ],
                  ),
                ),
              ),
          
              SizedBox(height: 10,),
              // Wrap(
              //   spacing: 10,
              //   runSpacing: 10,
              //   children: [
              //     HealthConcernItem(label: 'Cancer', imagePath: 'assets/droneicons/cancer.png'),
              //     HealthConcernItem(label: 'Diabetes', imagePath: 'assets/droneicons/diabetes.png'),
              //     HealthConcernItem(label: 'Fever', imagePath: 'assets/droneicons/fever.png'),
              //     HealthConcernItem(label: 'Kidney', imagePath: 'assets/droneicons/kidney.png'),
              //     HealthConcernItem(label: 'Liver', imagePath: 'assets/droneicons/liver.png'),
              //     HealthConcernItem(label: 'Wellness', imagePath: 'assets/droneicons/sex-education.png'),
              //   ],
              // ),
          
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: healthConcerns.length, // Use dynamic item count
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LabPackagesScreen(),));
                      },
                      child: TestCard(
                        title: healthConcerns[index]['label'] ?? 'Unknown', // Use default title if null
                        imagePath: healthConcerns[index]['imagePath'] ?? 'assets/default.png', // Default image path
                      ),
                    );
                  },
                ),
              ),
          
          
          
              // Book Popular Tests Section
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         "Book Popular Tests",
              //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //       ),
              //
              //       ViewMoreWidget(),
              //     ],
              //   ),
              // ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Popular Health',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LabPackagesScreen(),));
                        },
                        child: Text('View More', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: LabColors.primaryColor))),
                  ],
                ),
          
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0,),
                child: Text('Checkup Packages',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
          
              SizedBox(height: 10),
              SizedBox(
                height: 180,
                child: FutureBuilder<List<Package>>(
                  future: futurePackages,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Package package = snapshot.data![index];
                          return HealthPackageCard(
                            package: package,
                            onAddToCart: () => addToCart(package),
                            onRemoveFromCart: () => removeFromCart(package),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text('No packages available'));
                    }
                  },
                ),
              ),
          
              InkWell(
                onTap: (){
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => MyBookingsScreen(),));
          
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SectionHeader(title: 'Book Lab Tests', showMore: true),
                ),
              ),
          
              FutureBuilder<List<TestPackage>>(
                future: fetchTestPackages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!.map((package) => LabTestItem(
                        package: package,  // ✅ Pass TestPackage directly
                        onAddToCart: () => addToCartTest(package),
                        onRemoveFromCart: () => removeFromCartTest(package),
                      )).toList(),
                    );
                  } else {
                    return Center(child: Text('No packages available'));
                  }
                },
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SectionHeader(title: 'Best labs near you'),
              ),
              FutureBuilder<List<LabPackage>>(
                future: futureLabs, // Use the futureLabs here
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!.map((lab) => LabListItem(name: lab.name, location: lab.address)).toList(),
                    );
                  } else {
                    return Center(child: Text('No labs available'));
                  }
                },
              ),
            ],
          ),
                ),
        ),
    );
  }
}

class TestCard extends StatelessWidget {
  final String title;
  final String imagePath;

  const TestCard({required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LabColors.extraLightPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Image.asset(imagePath, width: 30, height: 30, errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.error, color: Colors.red); // Handle missing image
          }),
        ],
      ),
    );
  }
}



class Package {
  final int id;
  final String packageName;
  final String testNumber;
  final String about;
  final double price;
  final int testsLength;
  bool isInCart; // Add this line

  Package({
    required this.id,
    required this.packageName,
    required this.testNumber,
    required this.about,
    required this.price,
    required this.testsLength,
    this.isInCart = false, // Initialize to false
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      packageName: json['package_name'],
      testNumber: json['test_number'], // Ensure this matches the API response
      about: json['about'] ?? 'No description available',
      price: json['price']?.toDouble() ?? 0.0,
      testsLength: json['testslength'] ?? 0,
      isInCart: false,
    );
  }
}

class ViewMoreWidget extends StatelessWidget {
  const ViewMoreWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(6)
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0,right: 20.0,top:6,bottom: 6),
          child: Text("View more", style: TextStyle(color: Colors.white,fontSize: 12)),
        ));
  }
}

class HealthPackageCard extends StatelessWidget {
  final Package package;
  final Function() onAddToCart;
  final Function() onRemoveFromCart;

  const HealthPackageCard({
    required this.package,
    required this.onAddToCart,
    required this.onRemoveFromCart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 300,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: LabColors.extraLightPrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                package.packageName,
                style: TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.science, color: Colors.green, size: 16),
                  Text('${package.testsLength} Lab Tests'),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹ ${package.price.toStringAsFixed(0)}/-',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: package.isInCart ? onRemoveFromCart : onAddToCart,
                    style: ElevatedButton.styleFrom(backgroundColor: LabColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(package.isInCart ? 'Remove' : 'Add'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String imagePath; // Change from IconData to String for images
  final String label;

  CategoryItem({required this.imagePath, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LabPackagesScreen(),));
      },
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 50, // Adjust size as needed
            height: 50,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}




class SectionHeader extends StatelessWidget {
  final String title;
  final bool showMore;

  SectionHeader({required this.title, this.showMore = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        if (showMore)
          InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LabTestsScreen(),));
              },
              child: Text('View More', style: TextStyle(color: LabColors.primaryColor,fontWeight: FontWeight.bold,))),
      ],
    );
  }
}

class HealthConcernItem extends StatelessWidget {
  final String label;
  final String imagePath; // Changed from IconData to String for image path

  HealthConcernItem({required this.label, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          SizedBox(width: 8),
          Image.asset(
            imagePath,
            width: 30, // Adjust size as needed
            height: 30,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}


class FilterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.filter_list),
        SizedBox(width: 10),
        DropdownButton<String>(items: [], onChanged: (value) {}),
      ],
    );
  }
}

// Text(
//   '${package.about ?? 'No description available'}\nTest No: ${package.testNumber}',  // Handle null for 'about'
// ),  // Display description


class TestPackage {
  final int id;
  final String packageName;
  final String testNumber;
  final bool homeCollection;
  final String description;
  final double price;
  bool isInCart;

  TestPackage({
    required this.id,
    required this.packageName,
    required this.testNumber,
    required this.homeCollection,
    required this.description,
    required this.price,
    this.isInCart = false,
  });

  factory TestPackage.fromJson(Map<String, dynamic> json) {
    return TestPackage(
      id: json['id'],
      packageName: json['name'],
      testNumber: json['test_number'],
      homeCollection: json['home_collection'],
      description: json['description'],
      price: (json['mrp'] as num).toDouble(),
    );
  }
}

class LabTestItem extends StatefulWidget {
  final TestPackage package;
  final VoidCallback onAddToCart;
  final VoidCallback onRemoveFromCart;

  LabTestItem({
    required this.package,
    required this.onAddToCart,
    required this.onRemoveFromCart,
  });

  @override
  _LabTestItemState createState() => _LabTestItemState();
}

class _LabTestItemState extends State<LabTestItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text(widget.package.packageName, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('₹ ${widget.package.price.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: ElevatedButton(
          onPressed: () {
            setState(() {
              widget.package.isInCart = !widget.package.isInCart;
            });

            if (widget.package.isInCart) {
              widget.onAddToCart();
            } else {
              widget.onRemoveFromCart();
            }
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: widget.package.isInCart ? Colors.red : LabColors.primaryColor,
          ),
          child: Text(widget.package.isInCart ? 'Remove' : 'Add'),
        ),
      ),
    );
  }
}



class LabListItem extends StatelessWidget {
  final String name;
  final String location;

  LabListItem({required this.name, required this.location});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(location),
      trailing: Icon(Icons.star, color: Colors.orange),
    );
  }
}

class LabPackage {
  final int id;
  final String name;
  final String phoneNo;
  final String email;
  final String address;
  final String about;
  final List<int> testIds;
  final List<int> packageId;

  LabPackage({
    required this.id,
    required this.name,
    required this.phoneNo,
    required this.email,
    required this.address,
    required this.about,
    required this.testIds,
    required this.packageId,
  });

  factory LabPackage.fromJson(Map<String, dynamic> json) {
    return LabPackage(
      id: json['id'],
      name: json['name'],
      phoneNo: json['phone_no'],
      email: json['email'],
      address: json['address'],
      about: json['about'],
      testIds: List<int>.from(json['test_ids']),
      packageId: List<int>.from(json['package_id']),
    );
  }
}
class TestPackageCard extends StatefulWidget {
  final TestPackage testPackage;
  final VoidCallback onAddToCart;
  final VoidCallback onRemoveFromCart;

  TestPackageCard({
    required this.testPackage,
    required this.onAddToCart,
    required this.onRemoveFromCart,
  });

  @override
  _TestPackageCardState createState() => _TestPackageCardState();
}

class _TestPackageCardState extends State<TestPackageCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text(widget.testPackage.packageName, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('₹ ${widget.testPackage.price.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: ElevatedButton(
          onPressed: () {
            setState(() {
              widget.testPackage.isInCart = !widget.testPackage.isInCart;
            });

            widget.testPackage.isInCart ? widget.onAddToCart() : widget.onRemoveFromCart();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(widget.testPackage.isInCart ? 'Remove' : 'Add'),
        ),
      ),
    );
  }
}
