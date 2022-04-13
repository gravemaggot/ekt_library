<template lang="pug">
  div
    q-dialog(
      :value="true"
      no-route-dismiss="true"
      @hide="afterShow()"
      position="left"
      transition-show="flip-right"
    )
      q-card(style="width: 500px")
        q-form(enctype="multipart/form-data")
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
            //q-uploader(
            //  id="Обложка"
            //  filled
            //  ref="cover"
            //  style="width: auto"
            //  label="Обложка книги *")
            //input(type="file" ref="cover" @change="uploadFile()")
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
              @click="addBook"
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
	import { postBook, getCategories } from '../../api'
	import { Notify } from 'quasar'

	export default {
		data: function () {
			return {
				book: {
				  status: 'available'
        },
        categories: this.getCategories(),
        selectCategories: [],
        statuses: ['available', 'booking', 'reading'],
        errors: {},
        inputPicture: null
			}
		},
		created() {
		},
		methods: {
      uploadFile: function() {
        this.book.image = this.$refs.cover.files[0];
      },
			addBook() {
        this.book.category_ids = this.selectCategories.map(cat => cat.id)

        // let formData = new FormData()
        // Object.entries(this.book).forEach(
        //     ([key, value]) => formData.append(key, value)
        // );

        postBook(this.book)
          .then((response) => {
            Notify.create({
              message: "Книга '" + this.book.title + "' создана!",
              color: 'positive',
              position: 'top'
            });
            this.book = {};
            this.errors = {};
            // this.$refs.title.resetValidation();
          })
            .catch((error) => {
              this.hide="false";
              console.log("======ERROR======");
              console.log(error);
              console.log("=================");
              this.errors = true;
              Notify.create({
                message: "Книга не создана! Проверьте внесенные данные или обратитесь к администратору!",
                color: 'negative',
                position: 'top'
              })
            });
      },
      getCategories() {
        getCategories()
            .then((response) => {
              this.categories = response.data.categories
            })
            .catch((error) => {
              console.log(error);
              this.errors = true
            })
            .finally(() => {
              this.loading = false
            });
        },
			afterShow() {
        this.$router.push('/admin_books');
        this.$emit('refresh-list');
			}
		},
		components: {
			postBook,
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
