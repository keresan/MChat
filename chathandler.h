#ifndef CHATHANDLER_H
#define CHATHANDLER_H

#include <QObject>
#include <QtDebug>
#include <QJsonDocument>
#include <QAbstractListModel>
#include <QDateTime>

class MessageObject
{
public:
    QString type;
    QString message;
    QDateTime time;
    QString senderId;
};

class ChatHandler: public QAbstractListModel
{
    Q_OBJECT
public:

    enum RoleNames {
        TypeRole = Qt::UserRole,
        MessageRole,
        TimeRole,
        SenderIdRole,
    };


    ChatHandler(QObject *parent=Q_NULLPTR);
    ~ChatHandler();

    virtual int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    virtual QVariant data(const QModelIndex &index, int role) const override;

    Q_INVOKABLE void send_message(QVariantMap msg);

protected:
    virtual QHash<int, QByteArray> roleNames() const override;

signals:
    void message_arrived(QVariant msg);

private:
    QList<MessageObject*> _data;
    QHash<int, QByteArray> _roleNames;
};




#endif // CHATHANDLER_H
