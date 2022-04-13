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
            div(class="text-subtitle1") Выданные книги({{ book.reading_posts.length }}):
            div(v-for="post in book.reading_posts")
              q-chip(
                clickable
                @click="returnBook(post)"
                outline
                color="primary"
                text-color="white"
                icon="perm_identity"
              )
                | {{ (users.find(user => user.id === post.user_id)).full_name_str }} -- {{ new Date(post.created_at).toDateString() }}
            //q-select(
            //  id="Пользователь"
            //  filled
            //  label="Пользователь"
            //  placeholder="Выберите пользователя"
            //  v-model="user"
            //  :options="users"
            //  option-value="id"
            //  :option-label="(user) => [user.last_name + ' ' + user.first_name]"
            //  v-show="book.booking.all_amount === 0"
            //)
            q-card-section(align="center")
              //div(v-if="visible")
              //  q-rating(
              //    size="4em"
              //    color="orange"
              //    icon="star_border"
              //    icon-selected="star"
              //    v-model="input_rating"
              //  )
              //  div(v-if="input_rating != ''" )
              //    q-btn(
              //      flat
              //      color="orange"
              //      label="Добавить оценку"
              //      @click="addVote()"
              //      type="submit"
              //    )
              //q-btn(
              //  color="primary"
              //  label="Вернуть книгу в библиотеку"
              //  @click="returnBook()"
              //  type="submit"
              //  v-close-popup="hide"
              //)
            q-card-actions
              q-btn(
                flat
                color="primary"
                label="Закрыть"
                v-close-popup
              )
</template>

<script>
import {getBook, closePost, createRating, getUsers} from '../../api'
  import { Notify } from 'quasar'

  export default {
    data: function () {
      return {
        book: this.getBook(),
        input_rating: '',
        users: this.getUsers(),
        user: null,
        error: false,
        // hide: true,
        // visible: true
      }
    },
    created() {
    },
    watch: {
    },
    methods: {
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
      getBook() {
        getBook(this.$route.params.id)
          .then((response) => {
            this.book = response.data.data.attributes
          })
          .catch((error) => {
            console.log(error);
            this.error = true
          })
          .finally(() => {
            this.loading = false
          });
      },
      // addVote() {
      //   createRating({ value: this.input_rating, book_id: this.book.id, user_id: this.user.id })
      //     .then((response) => {
      //       Notify.create({
      //         message: "Добавлена оценка: " + this.input_rating,
      //         color: 'positive',
      //         position: 'top'
      //       });
      //       this.visible = false;
      //       this.$emit('refresh-list');
      //     })
      //     .catch((error) => {
      //       console.log(error)
      //       Notify.create({
      //         message: "Оценка не добавлена! Пользователь уже голосовал! ",
      //         color: 'negative',
      //         position: 'top'
      //       });
      //       this.visible = false;
      //       this.input_rating = ''
      //     })
      //     .finally(() => {
      //       this.loading = false
      //     });
      // },
      returnBook(post) {
        this.$q.dialog({
          title: "Провести возврат книги?",
          message: "Вы собираетесь вернуть книгу в библиотеку!",
          ok: {
            outline: true,
            color: 'positive',
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
                this.$emit('refresh-list');
                this.$router.go(-1);
                Notify.create({
                  message: "Книга возвращена!",
                  color: 'positive',
                  position: 'top'
                })
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
      afterShow() {
        this.$router.go(-1);
        this.$emit('refresh-list');
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
