<template lang="pug">
  div(class="q-pa-md")
    q-dialog(
      :value="true"
      @hide="afterShow()"
      :maximized="maximizedToggle"
      transition-show="slide-up"
      transition-hide="slide-down"
    )

      q-card(class="text-grey-10" style="width: 800px; max-width: 80vw;")
        q-bar(class="bg-primary text-white")
          div {{ book.short_title }}

          q-space

          //q-btn(dense flat icon="minimize" @click="maximizedToggle = false" :disable="!maximizedToggle")
          //q-btn(dense flat icon="crop_square" @click="maximizedToggle = true" :disable="maximizedToggle")
          q-btn(dense flat icon="close" v-close-popup)

        div(class="q-pa-md")
          q-card-section
            q-item
              q-img(:src="book.image_src" class="shadow-20" style="max-width: 350px")
                div(style="border-radius: 50%")
                  q-btn(name="add_to_wish" round flat text-color="white" size="20px" icon="favorite_border" @click="addWish()")
              q-card-section(align="middle")
                q-card-section
                  div(class="text-h5") {{ book.title }}
                  div(class="text-body1 text-grey-9") {{ book.author }}
                q-card-section
                  q-item-label(caption lines="1") Оценки {{ book.ratings_count }}
                  q-rating(size="2em" color="orange" icon="star_border" icon-selected="star" v-model="input_rating" @click="addVote()")
                q-card-section
                  div(class="text-h5")
                    div(:class="[status_arr[book.available][1]]" size="lg") {{ status_arr[book.available][0] }}
                    div(class="text-body1 text-grey-9") В наличии: {{ book.all_amount_with_booking }} шт.
                q-btn-group()
                  div(v-if="book.available")
                    q-btn(class="text-white bg-green" size="md" icon="bookmark" label="Зарезервировать" @click="bookingBook()")
                  div(v-else)
                    q-btn(class="text-white bg-grey" size="md" icon="bookmark" label="Зарезервировать" disable)
          q-card-section
            q-card-section
              span(v-for="category in book.categories")
                q-chip(square color="primary" text-color="white" :label="category.title")
              div(class="text-h6 text-grey-9") Описание:
              div(class="text-body1") {{ book.description }}
            q-card-section
              q-btn(type="a" :href="flibusta_link" target="_blank" outline no-caps icon="get_app" label="Flibusta")
                q-tooltip(anchor="bottom right" self="top right" transition-show="scale" transition-hide="scale" content-style="font-size: 12px")
                  | Найти и скачать с Флибуста — бесплатная некоммерческая онлайн-библиотека. Всего книг в библиотеке: 365 395 томов, 645 гигабайт
              q-btn(type="a" :href="librusec_link" target="_blank" outline no-caps icon="get_app" label="Librusec")
                q-tooltip(anchor="bottom right" self="top right" transition-show="scale" transition-hide="scale" content-style="font-size: 12px")
                  | Найти и скачать с Либрусек — бесплатная некоммерческая онлайн-библиотека. Всего книг в библиотеке: 226 000 томов, 374 гигабайт

          q-separator

          q-card-section
            div(class="text-h6 text-grey-9 q-pa-md") Комментарии ({{ book.comments_count }})
            q-intersection(v-for="comment in book.comments", :key="comment", once, transition="flip-right")
              q-list
                q-item(v-ripple)
                  q-item-section
                    q-item-label(caption lines="1") {{ comment.data.attributes.author }}
                    q-item-label(v-html="comment.data.attributes.body")
                  q-item-section(side)
                    | {{ comment.data.attributes.created }}
                    div(v-if="user.admin === true")
                      q-btn(
                        name="close_post"
                        flat
                        round
                        color="primary"
                        size="10px"
                        icon="close"
                        @click="destroyComment(comment.data.attributes)"
                      )
                q-separator(spaced inset)

            q-card-section(class="text-black")
              q-editor(v-model="new_comment", text-color="black", toolbar-text-color="white", toolbar-toggle-color="black", toolbar-bg="primary")
              q-btn(text-color="white" color="primary" label="Добавить комментарий" @click="addComment")

            //q-page-scroller(position="bottom-right" :scroll-offset="150" :offset="[18, 18]")
            //  q-btn(fab icon="keyboard_arrow_up" color="green")
</template>

<script>
	import { getBook, createComment, createRating, createPost, deleteComment } from '../../api'
  import { Notify } from 'quasar'

	export default {
		data () {
			return {
				book: {
				  title: '',
          author: '',
          status: '',
          image_src: '',
          ratings: [],
          comments: []
        },
        status_arr: {
          'false': ['НЕ ДОСТУПНА', 'text-grey'],
          'true': ['ДОСТУПНА', 'text-green']
        },
				error: false,
				hide: true,
        maximizedToggle: false,
        new_comment: '',
        input_rating: 0
			}
		},
		created() {
		  this.getBook();
		},
    computed: {
      user: {
        get() {
          return this.$store.state.currentUser
        },
      },
      flibusta_link() {
        return "http://flibusta.is/booksearch?ask=" + this.book.title
      },
      librusec_link() {
        return "https://librusec.pro/poisk/?navsrcq=" + this.book.title
      }
    },
		methods: {
			getBook() {
				getBook(this.$route.params.id)
					.then((response) => {
						this.book = response.data.data.attributes
            console.log(this.book);
            this.input_rating = this.book.calculate_rating
					})
					.catch((error) => {
						console.log(error);
						this.error = true
					})
					.finally(() => {
						this.loading = false
					});
      },
      bookingBook() {
        createPost({ title: 'booking', book_id: this.$route.params.id })
          .then((response) => {
            Notify.create({
              message: "Книга '" + this.book.title + "' зарезервирована!",
              color: 'positive',
              position: 'top'
            });
            this.getBook()
          })
            .catch((error) => {
              console.log(error);
              this.error = true
              Notify.create({
                message: "Книга уже была зарезервирована раньше!",
                color: 'negative',
                position: 'top'
              })
            });
      },
      addWish() {
        createPost({ title: 'wish', book_id: this.$route.params.id, active: false })
          .then((response) => {
            Notify.create({
              message: "Книга '" + this.book.title + "' добавлена в избранные!",
              color: 'positive',
              position: 'top'
            })
          })
          .catch((error) => {
            console.log(error);
            this.error = true
            Notify.create({
              message: "Книга уже была добавлена в избранные раньше!",
              color: 'negative',
              position: 'top'
            })
          });
      },
      addVote() {
        createRating({ value: this.input_rating, book_id: this.$route.params.id })
          .then((response) => {
            Notify.create({
              message: "Ваша оценка " + this.input_rating,
              color: 'positive',
              position: 'top'
            });
            this.getBook()
            this.$emit('add-vote');
          })
          .catch((error) => {
            console.log(error)
            Notify.create({
              message: "Вы уже голосовали!",
              color: 'negative',
              position: 'top'
            });
            this.input_rating = this.book.calculate_rating
          })
          .finally(() => {
            this.loading = false
          });
      },
      addComment() {
        createComment({ body: this.new_comment, book_id: this.$route.params.id })
          .then((response) => {
            Notify.create({
              message: "Комментарий добавлен!",
              color: 'positive',
              position: 'top'
            });
            this.new_comment = ''
            this.getBook()
            this.$emit('add-comment');
          })
          .catch((error) => {
            console.log(error);
            this.error = true
            Notify.create({
              message: "Ошибка добавления!",
              color: 'negative',
              position: 'top'
            })
          })
          .finally(() => {
            this.loading = false
          });
      },
      destroyComment(comment) {
        deleteComment(comment.id)
          .then((response) => {
            Notify.create({
              message: "Комментарий уделен!",
              color: 'positive',
              position: 'top'
            });
            this.getBook()
            this.$emit('add-comment');
          })
          .catch((error) => {
            console.log(error)
            this.error = true
            Notify.create({
              message: "Ошибка удаления!",
              color: 'negative',
              position: 'top'
            })
          })
          .finally(() => {
            this.loading = false
          });
      },
			afterShow() {
        this.$router.go(-1);
        this.$emit('refresh-list');
				// this.$router.go(-1);
			}
		},
		components: {
      Notify
		}
	}
</script>

<style scoped>
  p {
    font-size: 2em;
    text-align: center;
  }
</style>
