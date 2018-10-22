#ifndef CHATLISTMODEL_H
#define CHATLISTMODEL_H

#include <QObject>
#include <QtDebug>
#include <QAbstractListModel>
#include <QPointer>
#include <QDateTime>

class ChatManager;

class MessageItem
{
public:
    QString type;
    QString text;
    QDateTime time;
    QString senderId;
};

class MessageListModel: public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString userId READ userId WRITE setUserId NOTIFY userId_changed)
    Q_PROPERTY(QObject *chatManager READ chatManager WRITE setChatManager NOTIFY chatManager_changed)

public:

    enum RoleNames {
        TypeRole = Qt::UserRole,
        TextRole,
        TimeRole,
        SenderIdRole,
    };

    MessageListModel(QObject *parent=Q_NULLPTR);
    virtual ~MessageListModel() override;
    virtual int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    virtual QVariant data(const QModelIndex &index, int role) const override;

    Q_INVOKABLE void send_message(QString text, QString type=QString("chat"));

    QString userId();
    void setUserId(QString &userId);

    QObject * chatManager();
    void setChatManager(QObject *manager);

public slots:
    void message_arrived_from_manager(QString msg);

protected:
    virtual QHash<int, QByteArray> roleNames() const override;

signals:
    void message_arrived(QVariant msg);

    void userId_changed();
    void chatManager_changed();

private slots:
    void message_received(QString msg);

private:
    QList<MessageItem*> _data;
    QHash<int, QByteArray> _roleNames;
    QString _userId;

    QPointer<ChatManager> _manager;

    QString stringify_message(MessageItem &item);
    bool parse_message(const QString &message, MessageItem *item);
};

#endif // CHATLISTMODEL_H
