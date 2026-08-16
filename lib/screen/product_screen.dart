import 'package:flutter/material.dart';
import 'package:login_api/model/product_model.dart';
import 'package:login_api/service/api_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ApiService apiService = ApiService();

  bool isLoading = false;
  String? errorMessage;

  List<Products> products = [];

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      ProductResponse response = await apiService.getProducts();

      print('Total: ${response.total}');
      print('Product count: ${response.products?.length}');

      setState(() {
        products = response.products ?? [];
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products'), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : products.isEmpty
          ? const Center(child: Text('No products found'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                // Model object
                Products product = products[index];

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Image.network(
                          product.thumbnail ?? '',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.image, size: 40),
                            );
                          },
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(product.category ?? ''),

                              const SizedBox(height: 8),

                              Text(
                                '\$${product.price ?? 0}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5),
                                  Text('${product.rating ?? 0}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
