import 'package:flutter/material.dart';

// class SelectProfileImagePage extends StatelessWidget {
//   final Function(String) onImageSelected;

//   const SelectProfileImagePage({required this.onImageSelected, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Example image URLs (replace with actual URLs)
//     final List<String> imageUrls = [
//       'https://sketchok.com/images/articles/06-anime/002-one-piece/26/16.jpg',
//       'https://imgcdn.stablediffusionweb.com/2024/9/14/fb1914b4-e462-4741-b25d-6e55eeeacd0c.jpg',
//        'https://preview.redd.it/my-boa-hancock-attempt-v0-30ze1pt9g58c1.png?width=1280&format=png&auto=webp&s=31933400f61edfcd2007e6949af56e24d0522c07',
//       'https://imgcdn.stablediffusionweb.com/2024/10/7/16f5e32e-0833-425f-9c2a-6c07aae8c5ee.jpg',
//       'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/040dc617-5ca2-49ad-9518-65fd6ac1e816/anim=false,width=450/00218-2389552877.jpeg',
//        'https://i.pinimg.com/564x/78/fc/26/78fc26efc924e11c992afcf80c966a0f.jpg',
//       'https://wallpapers.com/images/hd/anime-girl-profile-pictures-kr6trv4dmtrqrbez.jpg',
//       'https://img.freepik.com/free-vector/young-man-with-glasses-avatar_1308-175763.jpg?t=st=1737359102~exp=1737362702~hmac=cf0e40c06d9f4e9c6ea250b792651bbde1673760167ac5215a93c7f85264f3e5&w=740',
//       'https://img.freepik.com/free-vector/man-traditional-red-costume_1308-175839.jpg?t=st=1737359134~exp=1737362734~hmac=064335dd4cee7220dabe4e1309044456caa9618c1516021d8e89283bf2cc19b4&w=740',
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select Profile Image'),
//         backgroundColor: Colors.black,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GridView.builder(
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//           ),
//           itemCount: imageUrls.length,
//           itemBuilder: (context, index) {
//             final imageUrl = imageUrls[index];
//             return GestureDetector(
//               onTap: () {
//                 onImageSelected(imageUrls[index]);
//                 Navigator.pop(context);
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.network(
//                     imageUrl,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
class SelectProfileImagePage extends StatelessWidget {
  final Function(String) onImageSelected;

  const SelectProfileImagePage({required this.onImageSelected, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
       'https://sketchok.com/images/articles/06-anime/002-one-piece/26/16.jpg',
      'https://imgcdn.stablediffusionweb.com/2024/9/14/fb1914b4-e462-4741-b25d-6e55eeeacd0c.jpg',
       'https://preview.redd.it/my-boa-hancock-attempt-v0-30ze1pt9g58c1.png?width=1280&format=png&auto=webp&s=31933400f61edfcd2007e6949af56e24d0522c07',
      'https://imgcdn.stablediffusionweb.com/2024/10/7/16f5e32e-0833-425f-9c2a-6c07aae8c5ee.jpg',
      'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/040dc617-5ca2-49ad-9518-65fd6ac1e816/anim=false,width=450/00218-2389552877.jpeg',
       'https://i.pinimg.com/564x/78/fc/26/78fc26efc924e11c992afcf80c966a0f.jpg',
      'https://wallpapers.com/images/hd/anime-girl-profile-pictures-kr6trv4dmtrqrbez.jpg',
      'https://img.freepik.com/free-vector/young-man-with-glasses-avatar_1308-175763.jpg?t=st=1737359102~exp=1737362702~hmac=cf0e40c06d9f4e9c6ea250b792651bbde1673760167ac5215a93c7f85264f3e5&w=740',
      'https://img.freepik.com/free-vector/man-traditional-red-costume_1308-175839.jpg?t=st=1737359134~exp=1737362734~hmac=064335dd4cee7220dabe4e1309044456caa9618c1516021d8e89283bf2cc19b4&w=740',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Profile Image'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        padding: const EdgeInsets.all(10),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              onImageSelected(imageUrls[index]); // Return selected image URL
              Navigator.pop(context); // Go back to the profile page
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(imageUrls[index], fit: BoxFit.cover),
                const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          );
        },
      ),
    );
  }
}
