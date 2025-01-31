import 'package:flutter/material.dart';
import 'package:services/constants/constants.dart';

class LabsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              filled: true,
              fillColor: Colors.grey[200],
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Horizontal Category Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CategoryCard(
                    title: "Book Lab Tests",
                    image: 'assets/images/d1/flask.png',
                  ),
                  CategoryCard(
                    title: "Popular Health Checks",
                    image: 'assets/images/d1/medical-report.png',
                  ),
                  CategoryCard(
                    title: "X-Ray, Scan & MRI",
                    image: "assets/images/d1/x-ray.png",
                  ),
                ],
              ),
            ),

            // Health Concern Tests Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Health Concern Tests",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold
                    ),
                  ),
                  ViewMoreWidget()
                ],
              ),
            ),
            SizedBox(height: 20,),
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
                itemCount: 6,
                itemBuilder: (context, index) {
                  return TestCard(title: "Diabetes");
                },
              ),
            ),

            SizedBox(height: 30,),
            // Book Popular Tests Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Book Popular Tests",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  ViewMoreWidget(),
                ],
              ),
            ),
            SizedBox(height: 10,),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return PopularTestCard(
                  title: "Hemoglobin Test",
                  price: "₹100",
                );
              },
            ),
          ],
        ),
      ),
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
          color: d1green,
          borderRadius: BorderRadius.circular(6)
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0,right: 20.0,top:6,bottom: 6),
          child: Text("View more", style: TextStyle(color: Colors.white,fontSize: 12)),
        ));
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String image;

  const CategoryCard({required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(image,height:60,width: 60,),
        SizedBox(height: 8),
        Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

class TestCard extends StatelessWidget {
  final String title;

  const TestCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Image.asset('assets/images/d1/flask.png')
        ],
      ),
    );
  }
}

class PopularTestCard extends StatelessWidget {
  final String title;
  final String price;

  const PopularTestCard({required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(price, style: TextStyle(color: Colors.green)),
        trailing: ElevatedButton(
          onPressed: () {},
          child: Text("Add"),
        ),
      ),
    );
  }
}
