const { onDocumentCreated } = require('firebase-functions/v2/firestore');
const { onSchedule } = require('firebase-functions/v2/scheduler');
const { onRequest } = require('firebase-functions/v2/https');
const { initializeApp } = require('firebase-admin/app');
const { getMessaging } = require('firebase-admin/messaging');
const { getFirestore } = require('firebase-admin/firestore');
const axios = require('axios');
const cheerio = require('cheerio');

initializeApp();
const db = getFirestore();

// 🔔 Chat Notification Function
exports.sendChatNotification = onDocumentCreated('messages/{chatId}/chat/{messageId}', async (event) => {
    const messageData = event.data.data();
    const chatId = event.params.chatId;

    if (!messageData) {
        console.log('No message data found.');
        return;
    }

    const notificationPayload = {
        topic: chatId,
        notification: {
            title: messageData.username || 'New Message',
            body: messageData.text || 'You have a new message',
        },
        data: {
            chatId: chatId,
            userId: messageData.userId,
            profileImage: messageData.profileImage || '',
        },
    };

    try {
        const response = await getMessaging().send(notificationPayload);
        console.log(`Notification sent to topic: ${chatId}`, response);
    } catch (error) {
        console.error('Error sending notification:', error);
    }
});

// 📰 Scraper core logic (reusable function)
const scrapeJfaNewsCore = async () => {
    const url = "https://jfa.com.jo/category.php?po=397&idcat=0&idsubcat=0&title=latest-news";

    try {
        const { data } = await axios.get(url);
        const $ = cheerio.load(data);

        const newsItems = [];

        $(".newscat").slice(0, 6).each((index, element) => {
            const title = $(element).find(".newscattext").text().trim();
            const imgUrl = $(element).find(".newscatpicimg").attr("src");
            const link = $(element).find("a").attr("href");
            const date = $(element).find(".cat1").text().trim();

            if (title && imgUrl && link) {
                newsItems.push({
                    id: `${Date.now()}_${index}`,
                    title,
                    imageUrl: imgUrl.startsWith("http") ? imgUrl : `https://www.jfa.jo/${imgUrl}`,
                    link: link.startsWith("http") ? link : `https://www.jfa.jo/${link}`,
                    category: "others",
                    team: "JFA",
                    Time: date,
                    content: link,
                });
            }
        });

        if (newsItems.length === 0) {
            console.log("No news items found to scrape.");
            return "No news found.";
        }

        const latestNewsCollection = db.collection("NewsLatest");
        const batch = db.batch();

        newsItems.forEach((item) => {
            const docRef = latestNewsCollection.doc(item.id);
            batch.set(docRef, item);
        });

        await batch.commit();
        console.log(`${newsItems.length} news items added to 'NewsLatest' collection`);
        return `Added ${newsItems.length} news items.`;
    } catch (error) {
        console.error("Error scraping JFA news:", error);
        return "Error scraping news.";
    }
};

// ⏰ Scheduled every 12h
exports.scrapeJfaNews = onSchedule('every 12 hours', async (event) => {
    console.log("Scheduled scrape triggered.");
    return await scrapeJfaNewsCore();
});

// 🖱️ Manual HTTP trigger
exports.scrapeJfaNewsNow = onRequest(async (req, res) => {
    console.log("Manual scrape triggered.");
    const result = await scrapeJfaNewsCore();
    res.send(result);
});
