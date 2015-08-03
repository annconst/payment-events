# language: ru
Функционал: тестирование страницы созданного события

Предыстория:
  Пусть я вхожу как авторизованный пользователь
  И я создаю событие
  И я нажимаю ссылку "show"
  И Обращение к sms.ru застаблено

@javascript
Сценарий: пригласить
  Пусть существует пользоваетель user2
  И я приглашаю пользователя user2
  И в базе количество "Invite" равно 1
  И я нажимаю ссылку "delete"
  И я подтверждаю
  И я жду 1 секунду
  И в базе количество "Invite" равно 0

@javascript
Сценарий: создать список продуктов
  И я создаю список продуктов
  Тогда в базе количество "ProductList" равно 1
  И я нажимаю ссылку "add_yourself"
  Тогда количество пользователей в списке равно 1
  И я нажимаю ссылку "exit_list"
  Тогда количество пользователей в списке равно 0
  И я создаю продукт в списке
  И я жду 1 секунду
  Тогда количество продуктов в списке равно 1
  И я нажимаю ссылку "delete"
  Тогда количество продуктов в списке равно 0
  И я нажимаю ссылку "delete_list"
  И в базе количество "ProductList" равно 0

@javascript
Сценарий: рассчитать и показать отчет
  Пусть существует пользоваетель user2
  И я создаю список продуктов
  И я нажимаю ссылку "add_yourself"
  И пользователь user2 добавлен в список
  И я жду 1 секунду
  И количество пользователей в списке равно 2
  И я создаю продукт в списке
  И я ввожу "100" в поле "products[1][price]"
  И я нажимаю кнопку "calculate"
  И я вижу "user1, user2, 50.0, 50.0"
  И я нажимаю ссылку "back"
  И я нажимаю ссылку "event_report"
  И я вижу "main product, bread"