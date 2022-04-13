<template lang="pug">
  div
    q-dialog(
      :value="true"
      @hide="afterShow()"
      position="right"
      transition-show="flip-right"
    )
      q-card(style="width: 600px")
        q-form
          q-card-section(class="q-gutter-y-md column")
            q-item-section
            q-input(
              filled
              ref="first_name"
              label="Имя *"
              placeholder="Имя пользователя"
              v-model="user.first_name"
              type="text"
            )
            q-input(
              filled
              ref="last_name"
              label="Фамилия *"
              placeholder="Фамилия пользователя"
              v-model="user.last_name"
              type="text"
            )
            q-input(
              filled
              ref="email"
              label="Email *"
              v-model="user.email"
              type="email"
            )
            q-input(
              filled
              ref="password"
              label="Пароль *"
              placeholder="Пароль пользователя"
              v-model="user.password"
              type="text"
            )
            q-toggle(
              color="blue"
              ref="admin"
              label="Администратор"
              v-model="user.admin"
              val="true"
            )
            q-separator(color="red")
            q-toggle(
              color="red"
              ref="deactivated"
              v-model="user.deactivated"
              val="true"
            ) 
              .text-red БЛОКИРОВКА
            q-separator(color="red")

            q-list(padding class="bg-blue-3" bordered class="rounded-borders")
              q-expansion-item(
                dense
                dense-toggle
                expand-separator
                icon="library_books"
                label="Информация о книгах")
                q-card
                  q-toolbar(class="bg-blue-2")
                    q-toolbar-title(align="middle") В резерве ({{ user.booking_count }})
                  div(v-for="post in user.booking")
                    q-list(bordered separator)
                      q-item
                        //- q-item-section(avatar)
                        //-   q-icon(name="")
                        q-item-section {{ post.title }}
                        q-item-section(side) {{ post.date }}
                  q-toolbar(class="bg-blue-2")
                    q-toolbar-title(align="middle") Читает ({{ user.reading_count }})
                  div(v-for="post in user.reading")
                    q-list(bordered separator)
                      q-item
                        q-item-section {{ post.title }}
                        q-item-section(side) {{ post.date }}
                  q-toolbar(class="bg-blue-2")
                    q-toolbar-title(align="middle") Прочитал ({{ user.reading_count }})
                  div(v-for="post in user.readed")
                    q-list(bordered separator)
                      q-item
                        q-item-section {{ post.title }}
                        q-item-section(side) {{ post.date }}

            q-btn(
              color="primary"
              label="СОХРАНИТЬ"
              @click="updateUser" 
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
	import { getUser, patchUser } from '../../api'
	import { Notify } from 'quasar'

	export default {
		data: function () {
			return {
				user: this.getUser(),
				errors: {},
				hide: true
			}
		},
		created() {
		},
		methods: {
			getUser() {
				getUser(this.$route.params.id)
					.then((response) => {
						this.user = response.data.user
					})
					.catch((error) => {
						console.log(error);
						this.errors = true
					})
					.finally(() => {
						this.loading = false
					});
      },
			updateUser() {
				patchUser(this.user)
					.then((response) => {
						Notify.create({
							message: "Пользователь '" + this.user.email + "' отредактирован!",
							color: 'positive',
							position: 'right'
						});
						this.$emit('edit-user');
						this.user = {};
						this.errors = {};
						// this.$refs.title.resetValidation();
					})
					.catch((error) => {
            console.log("======ERROR======");
            console.log(error);
            console.log("=================");
            this.errors = true;
            Notify.create({
              message: "Пользователь не отредактирован! Проверьте внесенные данные или обратитесь к администратору!",
              color: 'negative',
              position: 'top'
            })
						this.errors = error.response.data.errors;
					});
			},
			afterShow() {
				this.$router.push("/admin_users");
			}
		},
		components: {
			getUser,
			patchUser
		}
	}
</script>

<style scoped>
  p {
    font-size: 2em;
    text-align: center;
  }
</style>
