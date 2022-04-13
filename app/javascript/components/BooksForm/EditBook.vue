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
          q-card-section(class="q-gutter-y-md column")
            q-item-section
            q-input(
              filled
              ref="title"
              label="Наименование *"
              placeholder="Наименование книги"
              v-model="book.title"
              type="text"
            )
            q-input(
              filled
              ref="author"
              label="Автор *"
              placeholder="Автор(-ы) книги"
              v-model="book.author"
              type="text"
            )
            //q-input(
              filled
              ref="image"
              label="Изображение *"
              placeholder="ВРЕМЕННОЕ поле_изм_статусы - реализация в другой итерации"
              v-model="book.image"
              type="text"
            //)
            q-input(
              filled
              ref="image_src"
              label="Ссылка на обложку"
              placeholder="Внешняя ссылка на обложку"
              v-model="book.image_src"
              type="text"
            )
            q-input(
              filled
              ref="description"
              label="Описание *"
              placeholder="Описание книги"
              v-model="book.description"
              type="textarea"
            )
            q-select(
              filled
              multiple
              id="Категории"
              label="Категории"
              placeholder="Выберите категорию"
              v-model="selectCategories"
              :options="categories"
              use-chips
              stack-label
              option-value="id"
              option-label="title"
            )
            q-input(
              filled
              ref="number_of"
              label="Количество"
              placeholder="Количество книг(по умолчанию 1шт)"
              v-model="book.number_of"
              type="number"
            )
            q-btn(
              color="primary"
              label="СОХРАНИТЬ"
              @click="updateBook"
              v-close-popup
            )
            q-btn(
              flat
              color="primary"
              label="Закрыть"
              v-close-popup
            )
</template>

<script>
	import { getBook, patchBook, getCategories } from '../../api'
	import { Notify } from 'quasar'

	export default {
		data: function () {
			return {
				book: this.getBook(),
        categories: this.getCategories(),
        selectCategories: [],
        statuses: ['available', 'booking', 'reading']
			}
		},
		created() {
		},
    watch: {
		  book() {
		    this.selectCategories = this.book.categories
      }
    },
		methods: {
			getBook() {
				getBook(this.$route.params.id)
					.then((response) => {
						this.book = response.data.data.attributes
					})
					.catch((error) => {
						console.log(error);
						// this.errors = true
					})
					.finally(() => {
						this.loading = false
					});
      },
      getCategories() {
				getCategories()
					.then((response) => {
            this.categories = response.data.categories
					})
					.catch((error) => {
            console.log("======ERROR======");
            console.log(error);
            console.log("=================");
            this.errors = true;
            Notify.create({
              message: "Книга не отредактирована! Проверьте внесенные данные или обратитесь к администратору!",
              color: 'negative',
              position: 'top'
            })
					})
					.finally(() => {
						this.loading = false
					});
      },
			updateBook() {
        this.book.category_ids = this.selectCategories.map(cat => cat.id)
				patchBook(this.book)
					.then((response) => {
						Notify.create({
							message: "Книга '" + this.book.title + "' отредактирована!",
							color: 'positive',
							position: 'right'
						});
            // this.$emit('refresh-list');
						this.book = {};
						this.errors = {};
						// this.$refs.title.resetValidation();
					})
					.catch((error) => {
						this.errors = error.response.data.errors;
					});
			},
			afterShow() {
        this.$router.go(-1);
        this.$emit('refresh-list');
			}
		},
		components: {
			getBook,
			patchBook,
      getCategories
		}
	}
</script>

<style scoped>
  p {
    font-size: 2em;
    text-align: center;
  }
</style>
