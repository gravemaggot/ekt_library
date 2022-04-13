<template lang="pug">
  div(v-if="user" class="q-pa-md")
    q-layout(view="lhh lpR lff" container style="height: 95vh" class="shadow-5 rounded-borders")
      q-layout(view="hHh lpR fFf")
        header-component

        q-page-container

          router-view

          q-page-scroller(position="bottom")
            q-btn(fab icon="keyboard_arrow_up" color="green")
        footer-component
</template>

<script>
  import HeaderComponent from './components/Header'
  import BooksTable from './components/Tables/User/BooksTable'
  import FooterComponent from './components/Footer'
  import { currentUser } from "./api";

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
        set(value) {
          this.$store.commit('updateCurrentUser', value)
        }
      }
    },
    created() {
      this.fetchUser();
    },
    methods: {
      fetchUser() {
        currentUser()
            .then((response) => {
              this.user = response.data.user
            })
            .catch((error) => {
              console.log(error);
              this.error = true
            })
            .finally(() => {
              this.loading = false
            });
      }
    },
    components: {
			HeaderComponent,
			BooksTable,
      FooterComponent
    }
  }
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
