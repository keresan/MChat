#include "chatmanager.h"


ChatManager::ChatManager(QObject *parent)
    : QObject (parent)
{
}

ChatManager::~ChatManager()
{
}

bool ChatManager::registerMember(MessageListModel *item)
{
    if(_group.indexOf(item) >= 0) {
        return false;
    }

    QString msg = generate_info_message(item->userId() + " has joined the conversation.");
    send_message_to_all(msg);

    _group.append(item);

    msg = generate_info_message("Welcome in MChat.");
    send_message(item, msg);

    return true;
}

bool ChatManager::unregisterMember(MessageListModel *item)
{
    if(_group.indexOf(item) < 0) {
        return false;
    }

    _group.removeAll(item);

    QString msg = generate_info_message(item->userId() + " has left the conversation.");
    send_message_to_all(msg);

    return true;
}

void ChatManager::send_message_request(QString message)
{
    send_message_to_all(message);
}

void ChatManager::send_message(MessageListModel *receiver, QString &message)
{
    receiver->message_arrived_from_manager(message);
}

void ChatManager::send_message_to_all(QString &message)
{
    for(int i = 0; i < _group.size(); ++i) {
        _group.at(i)->message_arrived_from_manager(message);
    }
}

QString ChatManager::generate_info_message(const QString &info_text)
{
    MessageItem item;

    item.type = "info";
    item.text = info_text;
    item.senderId = "manager";
    item.time = QDateTime::currentDateTime();

    return stringify_message(item);
}

QString ChatManager::stringify_message(MessageItem &item)
{
    QJsonObject obj;

    obj.insert("type", item.type);
    obj.insert("text", item.text);
    obj.insert("time", item.time.toString());
    obj.insert("senderId", item.senderId);

    QJsonDocument doc(obj);
    QString str = doc.toJson(QJsonDocument::Compact);

    return str;
}

bool ChatManager::parse_message(const QString &message, MessageItem *item)
{
    QJsonParseError error;
    QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8(), &error);

    if(error.error != QJsonParseError::NoError) {
        qDebug() << "ChatManager::parse_message() ERROR" << error.errorString();
        return false;
    }

    QJsonObject obj = doc.object();

    item->type = obj.value("type").toString();
    item->text = obj.value("text").toString();
    item->time = QDateTime::fromString(obj.value("time").toString());
    item->senderId = obj.value("senderId").toString();

    return true;
}
