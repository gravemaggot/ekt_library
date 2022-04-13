<template lang="pug">
  div
    div(v-if="loading")
      q-page-container(align="middle")
        q-spinner(color="primary" size="7em" :thickness="10")
    div(v-else)
      div(v-if="error")
        p Error!
      div(v-else)
        q-toolbar(class="bg-light-blue-1")
          q-toolbar-title(align="middle") #читаю
        div(class='q-pa-md')
          q-table(
            separator="cell"
            name="books",
            :title="title",
            :data="data",
            :columns="columns",
            :pagination.sync="pagination",
            :rows-per-page-options="[10, 25, 100]",
            row-key="id"
            no-data-label="Нет книг на руках :( ")
            // Обложка
            template(v-slot:body-cell-image="props")
              q-td(align="center")
                q-img(
                  :src="props.row.image_src"
                  style="max-width: 60px; box-shadow: 0 0 5px;"
                  class="scale"
                  @click="showBook(props.row)"
                )
            // Наименование(название, автор, кол-во коммент)
            template(v-slot:body-cell-title="props")
              q-td(align="left")
                div
                  q-btn(flat color="primary" @click="showBook(props.row)" :label="props.row.title" action="show")
                    q-badge(color="green" icon="edit" floating) {{ props.row.comments_count }}
                    q-tooltip(
                      anchor="center right"
                      self="center left"
                      content-style="font-size: 12px"
                    ) {{ props.row.short_description }}
                div
                  q-chip(square outline color="blue-grey-6" :label="props.row.author")
            // Рейтинг
            template(v-slot:body-cell-rating="props")
              q-td(align="center")
                q-rating(
                  v-if="props.row.calculate_rating !== null"
                  readonly
                  size="1.5em"
                  color="orange"
                  icon="star_border"
                  icon-selected="star"
                  v-model="props.row.calculate_rating"
                )
                q-rating(
                  v-else
                  readonly
                  size="1.5em"
                  color="grey"
                  icon="star_border"
                  icon-selected="star"
                  v-model="null_rating"
                )
            // Категории
            template(v-slot:body-cell-categories="props")
              q-td(align="center")
                div(v-for="category in props.row.categories")
                  q-badge {{ category.title }}
            // Начал читать
            template(v-slot:body-cell-start_date_post="props")
              q-td(align="center")
                | {{ new Date(props.row.reading_posts.find(post => post.user_id === user.id).created_at).toDateString() }}
</template>

<script>
  import { getBooks, getCategories } from '../../../api'
  import { Notify } from 'quasar'

  export default {
    data() {
      return {
        columns: [
          { name: 'id',              label: 'ID',           align: 'left',   field: 'id',                                           sortable: true },
          { name: 'image',           label: 'Обложка',      align: 'center', field: 'image'                                                        },
          { name: 'title',           label: 'Наименование', align: 'left',   field: row => row.title,      format: val => '${val}', sortable: true },
          { name: 'rating',          label: 'Рейтинг',      align: 'center', field: row => row.calculate_rating,     format: val => '${val}', sortable: true },
          { name: 'categories',      label: 'Категории',    align: 'center', field: row => row.categories, format: val => '${val}'                 },
          { name: 'start_date_post', label: 'Начал читать', align: 'center', field: 'start_date',                                   sortable: true }
        ],
        data: [],
        title: '',
        categories: this.getCategories(),
        loading: true,
        error: false,
        ratingModel: 3,
        pagination: {
          rowsPerPage: 10
        },
      }
    },
    created() {
      this.fetchBooks();
    },
    computed: {
      user: {
        get() {
          return this.$store.state.currentUser
        },
      },
    },
    methods: {
      fetchBooks() {
        getBooks({ filter: 'reading' })
            .then((response) => {
              this.data = response.data.data.map(i => i.attributes);
              console.log(response)
            })
            .catch((error) => {
              console.log(error);
              this.error = true
            })
            .finally(() => {
              this.loading = false
            });
      },
      getCategories() {
        getCategories()
            .then((response) => {
              this.categories = response.data.categories.map(cat => cat.title)
            })
            .catch((error) => {
              console.log(error);
              this.errors = true
            })
            .finally(() => {
              this.loading = false
            });
      },
      showBook(book) {
        this.$router.push({ name: 'showBook', params: { id: book.id, url: '/reading_books' } })
      },
    },
    components: {
      Notify
    }
  }
</script>

<style>

</style>
