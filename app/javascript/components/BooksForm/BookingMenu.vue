<template lang="pug">
  div
    q-dialog(
      :value="true"
      @hide="afterShow()"
      position="right"
      transition-show="flip-left"
    )
      q-card(style="width: 500px")
        q-form
          q-card-section(class="bg-primary text-white")
            div(class="text-h6") {{ book.title }}
            div(class="text-subtitle2") {{ book.author }}
          q-separator
          q-card-section(align="center")
            div(class="text-subtitle1") Всего доступно книг: {{ book.all_amount }}
            div(class="text-subtitle1" v-show="book.booking_posts.length !== 0") Из них резервы({{ book.booking_posts.length }}):
            div(v-for="post in book.booking_posts")
              q-chip(removable size="md" icon="perm_identity" @remove="closePost(post)")
                | {{ (users.find(user => user.id === post.user_id)).full_name_str }} -- {{ new Date(post.created_at).toDateString() }}
            br
            q-separator
            br
            q-select(
              id="Пользователь"
              filled
              label="Пользователь"
              placeholder="Выберите пользователя"
              v-model="user"
              :options="users"
              option-value="id"
              :option-label="(user) => [user.last_name + ' ' + user.first_name]"
              v-show="book.booking_posts.all_amount !== 0"
            )
          q-card-actions
            q-btn(
              color="primary"
              label="Выдать"
              @click="giveOutBook"
              v-close-popup
              v-show="book.booking_posts.all_amount !== 0"
            )
            q-btn(
              flat
              color="primary"
              label="Закрыть"
              v-close-popup
            )
</template>

<script>
  import {getBook, getUsers, createPost, closePost} from '../../api'
  import { Notify } from 'quasar'

  export default {
    data: function () {
      return {
        book: this.getBook(),
        user: null,
        users: this.getUsers(),
        errors: {},
      }
    },
    created() {
    },
    watch: {
    },
    methods: {
      getBook() {
        getBook(this.$route.params.id)
          .then((response) => {
            // console.log(response.data)
            this.book = response.data.data.attributes
          })
          .catch((error) => {
            console.log(error);
            this.errors = true
          })
          .finally(() => {
            this.loading = false
          });
      },
      getUsers() {
        getUsers()
          .then((response) => {
            // console.log(response.data.users)
            this.users = response.data.users
          })
          .catch((error) => {
            console.log(error);
            this.errors = true
          })
          .finally(() => {
            this.loading = false
          });
      },
      closePost(post) {
        this.$q.dialog({
          title: "Закрыть резервирование?",
          message: "Вы собираетесь безвозвратно закрыть резервирование книги пользователем!",
          ok: {
            outline: true,
            color: 'negative',
            label: 'Да'
          },
          cancel: {
            flat: true,
            color: 'black',
            label: 'Нет'
          }
        }).onOk(() => {
          closePost(post.id)
              .then((response) => {
                this.getBook();
                Notify.create({
                  message: "Резервирование закрыто!",
                  color: 'negative'
                });
              })
              .catch((error) => {
                console.log(error);
                console.log("======ERROR======");
                console.log(error);
                console.log("=================");
                this.errors = true;
                Notify.create({
                  message: "ОШИБКА! Обратитесь к администратору!",
                  color: 'negative',
                  position: 'top'
                })
              });
        }).onCancel(() => {
          // console.log('Cancel')
        }).onDismiss(() => {
          // console.log('I am triggered on both OK and Cancel')
        })
      },
      giveOutBook() {
        createPost({ title: 'reading', book_id: this.book.id, user_id: this.user.id })
          .then((response) => {
            // console.log(response.data.book)
            // this.$emit('refresh-list');
            // this.$router.go(-1);
            Notify.create({
              message: "Книга '" + this.book.title + "' выдана!",
              color: 'positive',
              position: 'top'
            });
          })
          .catch((error) => {
            console.log(error);
            this.error = true
          });
      },
      afterShow() {
        this.$router.go(-1);
        this.$emit('refresh-list');
        // this.$emit('refresh-list');
        // this.$router.push("/admin_books");
        // this.$router.go(-1);
      }
    },
    components: {
    }
  }
</script>

<style scoped>
  p {
    font-size: 2em;
    text-align: center;
  }
</style>
