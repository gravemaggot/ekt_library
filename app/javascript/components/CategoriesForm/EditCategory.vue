<template lang="pug">
  div
    q-dialog(
      :value="true"
      @hide="afterShow()"
      position="right"
      transition-show="flip-right"
    )
      q-card(style="width: 500px")
        q-form
          q-card-section(class="q-gutter-y-md column")
            q-item-section
            q-input(
              filled
              ref="first_name"
              label="Наименование *"
              placeholder="Наименование категории"
              v-model="category.title"
              type="text"
            )
            q-btn(
              color="primary"
              label="СОХРАНИТЬ"
              @click="updateCategory"
              v-close-popup="hide"
            )
            q-btn(
              flat
              color="primary"
              label="Закрыть"
              v-close-popup
            )
</template>

<script>
	import { getCategory, patchCategory } from '../../api'
	import { Notify } from 'quasar'

	export default {
		data: function () {
			return {
				category: this.getCategory(),
				errors: {},
				hide: true
			}
		},
		created() {
		},
		methods: {
			getCategory() {
				getCategory(this.$route.params.id)
					.then((response) => {
						this.category = response.data.category
					})
					.catch((error) => {
						console.log(error);
						this.errors = true
					})
					.finally(() => {
						this.loading = false
					});
      },
			updateCategory() {
				patchCategory(this.category)
					.then((response) => {
						Notify.create({
							message: "Категория '" + this.category.title + "' отредактирована!",
							color: 'positive',
							position: 'right'
						});
						this.$emit('edit-category');
						this.category = {};
						this.errors = {};
						// this.$refs.title.resetValidation();
					})
					.catch((error) => {
            console.log("======ERROR======");
            console.log(error);
            console.log("=================");
            this.errors = true;
            Notify.create({
              message: "Категория не отредактирована! Проверьте внесенные данные или обратитесь к администратору!",
              color: 'negative',
              position: 'top'
            })
						this.errors = error.response.data.errors;
					});
			},
			afterShow() {
				this.$router.push("/admin_categories");
			}
		},
		components: {
			getCategory,
			patchCategory
		}
	}
</script>

<style scoped>
  p {
    font-size: 2em;
    text-align: center;
  }
</style>
