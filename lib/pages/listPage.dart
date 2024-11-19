import 'package:flutter/material.dart';
import 'package:latres/api/apiService.dart';
import 'package:latres/models/contentModel.dart';
import 'package:latres/pages/detailPage.dart';

class ListPage extends StatelessWidget {
  final String type;

  const ListPage({required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          type.toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<ContentModel>>(
        future: ApiService.fetchData(type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final data = snapshot.data ?? [];
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        id: item.id,
                        type: type,
                        url: item.url,
                        title: item.title,
                        imageUrl: item.imageUrl,
                        summary: item.summary,
                        newsSite: item.newsSite,
                        publishedAt: item.publishedAt,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.imageUrl,
                              fit: BoxFit.cover,
                              height: 100,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.image_not_supported,
                                    size: 100);
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Text(
                                item.summary,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Text(
                                _formatDate(item.publishedAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null) return '';
    try {
      final parsedDate = DateTime.parse(date);
      return "${parsedDate.day}-${parsedDate.month}-${parsedDate.year}";
    } catch (e) {
      return date;
    }
  }
}
