# language: ru
Функционал: тестирование приглашений

Предыстория:
  Пусть я вхожу как авторизованный пользователь
  И я создаю событие
  И я нажимаю ссылку "show"
  И Обращение к sms.ru застаблено
  И существует пользоваетель user2
  И я приглашаю пользователя user2
  И я выхожу со своей страницы

@javascript
Сценарий: принять приглашение
  И я авторизируюсь под пользователем user2
  И я создаю событие
  И я нажимаю ссылку "invites"
  И я вижу "User2, you are invited to the following events, Test, Accept, Reject"
  И я нажимаю ссылку "accept"
  И я нажимаю ссылку "my_event"
  И количество моих событий 2

Сценарий: отклонить приглашение
  И я авторизируюсь под пользователем user2
  И я нажимаю ссылку "invites"
  И я нажимаю ссылку "reject"
  И количество моих событий 0