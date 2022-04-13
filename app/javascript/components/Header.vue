<template lang="pug">
  div
    q-header(elevated class="bg-primary text-white" view="hHh lpR fFf" container)
      q-toolbar(class="toolbar")
        q-btn(flat round dense icon="menu" @click="left = !left")

        q-item

        a(href="/")
          img(src="../images/logo_book_4.png" alt="EKTlibrary" width="60" align="middle")

        q-toolbar-title БИБЛИОТЕКА
          q-badge(align="top" color="orange") v2.1.0b

        //div(class="toolbar-input-container justify-center")
          q-input(dark dense standout placeholder="Книга, автор" v-model="search_text" input-class="text-left" class="q-ml-md")
            template(v-slot:append)
              q-btn(v-if="search_text === ''" flat disabled icon="search") Найти
              div(v-else)
                q-btn(flat icon="search" @click="search") Найти
        //q-space

        div
          profile-menu

    q-drawer(
      v-model="left"
      show-if-above

      :mini="miniState"
      @mouseover="miniState = false"
      @mouseout="miniState = true"
      mini-to-overlay

      :width="220"
      :breakpoint="500"
      bordered
      content-class="bg-grey-3")
      q-scroll-area(class="fit")
        q-separator
        user-left-menu

</template>

<script>
  import ProfileMenu from './Profile'
  import UserLeftMenu from './Tables/User/UserLeftMenu'

	export default {
		data: function () {
			return {
			  left: false,
        miniState: true,
        search_text: ''
      }
		},
		created() {
		},
		methods: {
		  // search() {
      //   this.$router.push({ name: 'ListBooks', params: { filter: this.search_text } })
      //   this.search_text = ''
      // }
		},
		components: {
      ProfileMenu,
      UserLeftMenu
		}
	}
</script>

<style scoped>
  p {
    font-size: 2em;
    text-align: center;
  }

  .toolbar {
    height: 60px
  }

  .toolbar-input-container {
     min-width: 100px;
     width: 55%
  }

</style>
