#include "chathandler.h"

ChatHandler::ChatHandler(QObject *parent)
    :QAbstractListModel(parent)
{
    _roleNames[TypeRole] = "type";
    _roleNames[MessageRole] = "message";
    _roleNames[TimeRole] = "time";
}

ChatHandler::~ChatHandler()
{
    for(int i = 0; i < _data.size(); ++i) {
        delete _data.at(i);
    }

    _data.clear();
}

int ChatHandler::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return _data.size();
}

QVariant ChatHandler::data(const QModelIndex &index, int role) const
{
    int row = index.row();
    if(row < 0 || row >= _data.size()) {
        return QVariant();
    }

    MessageObject *object = _data.at(row);

    switch (role) {
        case TypeRole: return object->type;
        case MessageRole: return object->message;
        case TimeRole: return object->time;
    }

    return QVariant();
}

void ChatHandler::send_message(QVariantMap msg)
{
    QJsonDocument doc = QJsonDocument::fromVariant(msg);
    emit message_arrived(doc.toVariant());
}

QHash<int, QByteArray> ChatHandler::roleNames() const
{
    return _roleNames;
}
