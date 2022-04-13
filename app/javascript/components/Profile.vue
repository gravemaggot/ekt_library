<template lang="pug">
  div
    | {{ user.email }}
    q-btn(flat round dense icon="account_circle" name="profile")
      q-menu(auto-close transition-show="scale" transition-hide="scale")
        q-list(style="min-width: 200px")
          q-item(v-close-popup)
            q-item-section(class="text-primary") {{ user.first_name }} {{ user.last_name }}
          q-separator
          div(v-if="user.admin == true" class="text-negative")
            q-item(v-close-popup)
              q-item-section(class="text-negative") АДМИНИСТРИРОВАНИЕ
            q-item(to="/admin_books" v-ripple)
              q-item-section(avatar)
                q-icon(name="library_books")
              q-item-section
                | Книги
            q-item(to="/admin_categories" v-ripple)
              q-item-section(avatar)
                q-icon(name="all_inbox")
              q-item-section
                | Категории
            q-item(to="/admin_users" v-ripple)
              q-item-section(avatar)
                q-icon(name="supervised_user_circle")
              q-item-section
                | Пользователи
            q-separator
            q-item(to="/index_posts" class="text-negative" v-ripple)
              q-item-section(avatar)
                q-icon(name="auto_stories")
              q-item-section
                | Отчет по прочитанным
          q-separator
          q-item(v-close-popup)
            q-item-section
              q-btn(
                type="a"
                href="/users/sign_out"
                color="primary"
                size="10px"
                text-color="white"
                label="Выйти"
              )
</template>

<script>
	import { currentUser } from '../api/index'

	export default {
		data: function () {
			return {
			}
		},
    computed: {
      user: {
        get() {
          return this.$store.state.currentUser
        },
        // set(value) {
        //   this.$store.commit('updateCurrentUser', value)
        // }
      }
    },
		// created() {
		// 	this.fetchUser();
		// },
		// methods: {
		// 	fetchUser() {
		// 		currentUser()
		// 			.then((response) => {
		// 				this.user = response.data.user
		// 			})
		// 			.catch((error) => {
		// 				console.log(error);
		// 				this.error = true
		// 			})
		// 			.finally(() => {
		// 				this.loading = false
		// 			});
		// 	}
		// },
		components: {
		}
	}
</script>

<style scoped>
  my-menu-link {
    color: white;
    background: #F2C037;
  }
</style>
