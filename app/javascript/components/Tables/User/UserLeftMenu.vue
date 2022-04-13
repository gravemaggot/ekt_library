<template lang="pug">
  div
    q-list(padding)
      q-item(to="/list_books" v-ripple)
        q-item-section(avatar)
          q-icon(name="library_books")
        q-item-section
          | Все книги
      q-item(to="/reserved_books" v-ripple)
        q-item-section(avatar)
          q-icon(name="book")
        q-item-section
          | Зарезервировал
      q-item(to="/reading_books" v-ripple)
        q-item-section(avatar)
          q-icon(name="chrome_reader_mode")
        q-item-section
          | Читаю
      q-item(to="/readed_books" v-ripple)
        q-item-section(avatar)
          q-icon(name="done_all")
        q-item-section
          | Прочитал
      q-item(to="/wish_list" v-ripple)
        q-item-section(avatar)
          q-icon(name="favorite_border")
        q-item-section
          | Избранные
</template>
