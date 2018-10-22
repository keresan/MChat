#include "messagelistmodel.h"
#include "chatmanager.h"

MessageListModel::MessageListModel(QObject *parent)
    :QAbstractListModel(parent)
{
    _roleNames[TypeRole] = "type";
    _roleNames[TextRole] = "text";
    _roleNames[TimeRole] = "time";
    _roleNames[SenderIdRole] = "sender_id";
}

MessageListModel::~MessageListModel()
{
    for(int i = 0; i < _data.size(); ++i) {
        delete _data.at(i);
    }

    _data.clear();

    if(_manager) {
        _manager->unregisterMember(this);
    }
}

int MessageListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return _data.size();
}

QVariant MessageListModel::data(const QModelIndex &index, int role) const
{
    int row = index.row();
    if(row < 0 || row >= _data.size()) {
        return QVariant();
    }

    MessageItem *object = _data.at(row);

    switch (role) {
    case TypeRole: return object->type;
    case TextRole: return object->text;
    case TimeRole: return object->time;
    case SenderIdRole: return object->senderId;
    }

    return QVariant();
}

void MessageListModel::send_message(QString text, QString type)
{
    MessageItem item;
    item.type = type;
    item.text = text;
    item.senderId = userId();
    item.time = QDateTime::currentDateTime();

    QString msg = ChatManager::stringify_message(item);

    _manager->send_message_request(msg);
}

QString MessageListModel::userId()
{
    return _userId;
}

void MessageListModel::setUserId(QString &userId)
{
    if(_userId != userId) {
        _userId = userId;
        emit userId_changed();
    }
}

QObject *MessageListModel::chatManager()
{
    return _manager;
}

void MessageListModel::setChatManager(QObject *manager)
{
    if(_manager == manager) {
        return;
    }

    ChatManager *src_manager = qobject_cast<ChatManager*>(manager);
    if(!src_manager) {
        qDebug() << "MessageListModel::setChatManager() uncompatible type";
        return;
    }

    if(_manager) {
        _manager->unregisterMember(this);
    }

    _manager = src_manager;
    _manager->registerMember(this);
    emit chatManager_changed();
}

void MessageListModel::message_arrived_from_manager(QString msg)
{
    message_received(msg);
}

QHash<int, QByteArray> MessageListModel::roleNames() const
{
    return _roleNames;
}

void MessageListModel::message_received(QString msg)
{
    MessageItem *item = new MessageItem();

    bool r = ChatManager::parse_message(msg, item);
    if(!r) {
        qDebug() << "MessageListModel::message_received() PARSE ERROR";

        return;
    }

    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    _data.append(item);
    endInsertRows();
}
