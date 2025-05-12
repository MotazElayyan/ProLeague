const { onDocumentCreated } = require('firebase-functions/v2/firestore');
const { initializeApp } = require('firebase-admin/app');
const { getMessaging } = require('firebase-admin/messaging');
const { getFirestore } = require('firebase-admin/firestore');

initializeApp();

exports.sendChatNotification = onDocumentCreated('messages/{chatId}/chat/{messageId}', async (event) => {
    const messageData = event.data.data();
    const chatId = event.params.chatId;

    if (!messageData) {
        console.log('No message data found.');
        return;
    }

    console.log(`New message received in chat ${chatId}:`, messageData.text);

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
        return response;
    } catch (error) {
        console.error('Error sending notification:', error);
        return;
    }
});
