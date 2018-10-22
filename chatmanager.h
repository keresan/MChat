#ifndef CHATMANAGER_H
#define CHATMANAGER_H

#include <QObject>
#include <QDateTime>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include "messagelistmodel.h"

class ChatManager: public QObject
{
    Q_OBJECT

public:
    explicit ChatManager(QObject *parent=Q_NULLPTR);
    virtual ~ChatManager();

    bool registerMember(MessageListModel *item);
    bool unregisterMember(MessageListModel *item);

    static QString stringify_message(MessageItem &item);
    static bool parse_message(const QString &message, MessageItem *item);

public slots:
    void send_message_request(QString message);

private:
    void send_message(MessageListModel *receiver, QString &message);
    void send_message_to_all(QString &message);

    QString generate_info_message(const QString &info_text);

    QList<MessageListModel*> _group;
};

#endif // CHATMANAGER_H
