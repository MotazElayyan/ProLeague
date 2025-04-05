class NewsItem {
  final String Id;
  final String Title;
  final String ImgUrl;
  final String Category;
  final String author;
  final String Time;
  final String link;

  NewsItem({
    required this.Id,
    required this.Title,
    required this.ImgUrl,
    required this.Category,
    required this.author,
    required this.Time,
    required this.link
  });
}

List<NewsItem> News = [
  NewsItem(
    Id: '1',
    Title: 'إعلان قائمة المنتخب الوطني النسوي ت20 لبطولة غرب آسيا للشابات',
    ImgUrl: 'https://www.jfa.jo/images/pic/lpic/2025-04/67ed278047d39.jpg',
    Category: 'National Team',
    author: 'JFA',
    Time: '2025-04-02 15:03:12',
    link: 'https://jfa.com.jo/news.php?id=30386&title=%D8%A5%D8%B9%D9%84%D8%A7%D9%86-%D9%82%D8%A7%D8%A6%D9%85%D8%A9-%D8%A7%D9%84%D9%85%D9%86%D8%AA%D8%AE%D8%A8-%D8%A7%D9%84%D9%88%D8%B7%D9%86%D9%8A-%D8%A7%D9%84%D9%86%D8%B3%D9%88%D9%8A-%D8%AA20-%D9%84%D8%A8%D8%B7%D9%88%D9%84%D8%A9-%D8%BA%D8%B1%D8%A8-%D8%A2%D8%B3%D9%8A%D8%A7-%D9%84%D9%84%D8%B4%D8%A7%D8%A8%D8%A7%D8%AA',
  ),
  NewsItem(
    Id: '2',
    Title:
        'الأسبوع الثامن عشر من الدوري الأردني للمحترفين CFI ينطلق.. غداً الخميس',
    ImgUrl: 'https://www.jfa.jo/images/pic/lpic/67dc157a436b4.png',
    Category: 'League',
    author: 'JFA',
    Time: '2025-04-02 12:45:02',
    link: 'https://jfa.com.jo/news.php?id=30385&title=%D8%A7%D9%84%D8%A3%D8%B3%D8%A8%D9%88%D8%B9-%D8%A7%D9%84%D8%AB%D8%A7%D9%85%D9%86-%D8%B9%D8%B4%D8%B1-%D9%85%D9%86-%D8%A7%D9%84%D8%AF%D9%88%D8%B1%D9%8A-%D8%A7%D9%84%D8%A3%D8%B1%D8%AF%D9%86%D9%8A-%D9%84%D9%84%D9%85%D8%AD%D8%AA%D8%B1%D9%81%D9%8A%D9%86-CFI-%D9%8A%D9%86%D8%B7%D9%84%D9%82..-%D8%BA%D8%AF%D8%A7%D9%8B-%D8%A7%D9%84%D8%AE%D9%85%D9%8A%D8%B3',
  ),
  NewsItem(
    Id: '3',
    Title: 'منتخب النشميات يواصل تدريباته استعداداً لمواجهة نظيره المصري ودياً',
    ImgUrl: 'https://www.jfa.jo/images/pic/lpic/2025-04/67ec2dd7e5677.jpg',
    Category: 'National Team',
    author: 'JFA',
    Time: '2025-04-01 21:17:59',
    link: 'https://jfa.com.jo/news.php?id=30384&title=%D9%85%D9%86%D8%AA%D8%AE%D8%A8-%D8%A7%D9%84%D9%86%D8%B4%D9%85%D9%8A%D8%A7%D8%AA-%D9%8A%D9%88%D8%A7%D8%B5%D9%84-%D8%AA%D8%AF%D8%B1%D9%8A%D8%A8%D8%A7%D8%AA%D9%87-%D8%A7%D8%B3%D8%AA%D8%B9%D8%AF%D8%A7%D8%AF%D8%A7%D9%8B-%D9%84%D9%85%D9%88%D8%A7%D8%AC%D9%87%D8%A9-%D9%86%D8%B8%D9%8A%D8%B1%D9%87-%D8%A7%D9%84%D9%85%D8%B5%D8%B1%D9%8A-%D9%88%D8%AF%D9%8A%D8%A7%D9%8B',
  ),
];
