<template lang="pug">
  div
    q-dialog(
      :value="true"
      @hide="afterShow()"
      position="left"
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
              @click="addCategory"
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
  import { postCategory } from '../../api'
  import { Notify } from 'quasar'

	export default {
		data: function () {
			return {
				category: {},
        errors: {},
        hide: true
      }
		},
		created() {
		},
		methods: {
			addCategory() {
        postCategory(this.category)
					.then((response) => {
						Notify.create({
							message: "Категория '" + this.category.title + "' создана!",
							color: 'positive',
							position: 'top'
						});
						this.$emit('add-category');
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
              message: "Категория не создана! Проверьте внесенные данные или обратитесь к администратору!",
              color: 'negative',
              position: 'top'
            })
					});
      },
      afterShow() {
				this.$router.push("/admin_categories");
      }
		},
		components: {
			postCategory,
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
