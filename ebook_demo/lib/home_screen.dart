import 'package:flutter/material.dart';
import 'book.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thư Viện Sách'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: sampleBooks.length,
        itemBuilder: (context, index) {
          final book = sampleBooks[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Image.asset(
                book.coverUrl,
                width: 50,
                height: 70,
                fit: BoxFit.cover,
              ),
              title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(book.author),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // chuyen sang man detail
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(book: book),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
  // ds sach mau
  final List<Book> sampleBooks = [
    Book(
      title: "Đắc Nhân Tâm",
      author: "Dale Carnegie",
      coverUrl: "assets/images/Ebook-Dac-nhan-tam.jpg",
      chapters: [
        """Cha đã lẻn vào phòng con khi con đang ngủ. Một tay cha đặt lên trán con, những lọn tóc đẫm mồ hôi bết chặt vào vầng trán thơ ngây. Cha đã một mình suy ngẫm về những điều mình đã làm với con.

Suốt ngày qua cha đã đóng vai một người cha nghiêm khắc, hay gắt gỏng và phê phán. Cha mắng con khi con đang mặc quần áo đi học vì con chỉ lau mặt qua quýt bằng khăn ướt, cha sừng sộ khi thấy con chưa lau sạch giày. Cha giận dữ quát lên khi con đánh rơi vật gì đó xuống sàn nhà.

Cha luôn nhìn con bằng cặp mắt của một người trưởng thành đầy ích kỷ, đòi hỏi ở một đứa trẻ những điều mà ngay cả người lớn đôi khi cũng không làm được...""",

        """Bí mật lớn nhất trong giao tiếp chính là khả năng hiểu và khơi gợi được khao khát của người khác. Mỗi con người sinh ra trên đời đều mong muốn được công nhận và cảm thấy mình quan trọng.

Nếu bạn có thể khen ngợi một ai đó một cách chân thành, không vụ lợi, bạn đã nắm giữ được chìa khóa mở lối vào trái tim của họ. Đừng bao giờ tiếc nuối những lời khen ngợi đúng lúc...""",
      ],
    ),
    Book(
      title: "Nhà Giả Kim",
      author: "Paulo Coelho",
      coverUrl: "assets/images/nha-gia-kim.jpg",
      chapters: [
        """Cậu bé chăn cừu tên là Santiago. Khi cậu cùng đàn cừu đến một ngôi nhà thờ cổ bỏ hoang thì trời đã sập tối. Ngôi nhà thờ này đã sập mái từ lâu và một cây vả khổng lồ đã mọc lên ngay nơi trước kia là phòng thánh.

Cậu quyết định qua đêm tại đây. Cậu lùa đàn cừu qua khung cửa đổ nát rồi chắn lại bằng mấy thanh gỗ để chúng khỏi đi lạc trong đêm. Santiago trải tấm áo khoác dày xuống nền đất, gối đầu lên cuốn sách vừa đọc xong và nhắm mắt lại...""",

        """Mọi người khi còn trẻ đều biết vận mệnh của mình là gì. Vào giai đoạn ấy của cuộc đời, mọi thứ đều rõ ràng, mọi thứ đều có thể và người ta không sợ ước mơ, không sợ khao khát những điều họ muốn thấy xảy ra trong đời.

Thế nhưng, theo thời gian, một thần lực bí ẩn sẽ tìm cách chứng minh rằng chúng ta không thể nào đạt được vận mệnh của mình. Nhưng thực ra, chính những thử thách đó mới nhào nặn nên một nhà giả kim thực thụ...""",
      ],
    ),
  ];
}