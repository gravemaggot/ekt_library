<template lang="pug">
  div
    div(v-if="loading")
      q-page-container(align="middle")
        q-spinner(color="primary" size="7em" :thickness="10")
    div(v-else)
      div(v-if="error")
        p Error!
      div(v-else)
        div(v-if="user.admin == true")
          q-page-sticky(expand position="top")
            q-toolbar(class="bg-negative glossy text-white")
              q-toolbar-title(align="middle")
                | Категории(АДМИНИСТРИРОВАНИЕ)
          div(class='q-pa-md')
            q-table(
              separator="cell"
              name="categories",
              :title="title",
              :data="data",
              :columns="columns",
              :pagination.sync="pagination",
              :rows-per-page-options="[10, 25, 100]",
              row-key="id"
              no-data-label="Нет информации о категориях!")
              template(v-slot:body-cell-books="props")
                q-td(align="center")
                  div(class="book-count") {{ props.row.books.length }}
              template(v-slot:body-cell-action="props")
                q-td(align="right")
                  q-btn-group(flat)
                    q-btn(flat color="white" text-color="secondary" size="12px" icon="edit" label="Редактировать"  @click="editCategory(props.row)")
                    q-btn(flat color="white" text-color="negative" size="12px" icon="delete_forever" label="Удалить"  @click="deleteCategory(props.row)" method="delete")

            q-page-sticky(position="bottom-left" :offset="[18, 18]")
              q-btn(fab color="primary" @click="newCategory()" icon="add" name="Новая категория")
          router-view(@add-category="fetchCategories" @edit-category="fetchCategories")
</template>

<script>
	import { getCategories, deleteCategory } from '../../../api'
  import NewCategory from '../../CategoriesForm/CreateCategory'
  import EditCategory from '../../CategoriesForm/EditCategory'
  import { Notify } from 'quasar'

  export default {
		data() {
			return {
				columns: [
          { name: 'id', align: 'left', label: 'ID', field: 'id', sortable: true },
          { name: 'title', required: true, label: 'Наименование', align: 'left', field: 'title', sortable: true },
          { name: 'books', required: true, label: 'Количество книг', align: 'center', field: 'books.count', sortable: true },
					{ name: 'action', align: 'center', field: ['edit', 'delete'] }
        ],
				data: [],
        pagination: {
          rowsPerPage: 10
        },
				title: '',
				loading: true
			}
			error: {}
		},
    computed: {
      user: {
        get() {
          return this.$store.state.currentUser
        }
      }
    },
    created() {
			this.fetchCategories();
		},
    methods: {
			fetchCategories() {
				getCategories()
					.then((response) => {
						this.data = response.data.categories
					})
					.catch((error) => {
						console.log(error);
						this.error = true
					})
					.finally(() => {
						this.loading = false
					});
      },
      newCategory() {
				this.$router.push({ name: 'createCategory'})
      },
      editCategory(category) {
        this.$router.push({ name: 'editCategory', params: { id: category.id } })
      },
      deleteCategory(category) {
        this.$q.dialog({
          title: "Удалить категорию '" + category.title + "' ?",
          message: "Вы собираетесь безвозвратно удалить категорию '" + category.title + "' !",
          ok: {
            outline: true,
            color: 'negative',
            label: 'Да'
          },
          cancel: {
            flat: true,
            color: 'black',
            label: 'Нет'
          }
        }).onOk(() => {
          deleteCategory(category.id)
            .then((response) => {
              this.fetchCategories();
              Notify.create({
                message: "Категория '" + category.title + "' удалена!",
                color: 'negative'
              })
            })
            .catch((error) => {
              console.log(error);
              this.error = true
            });
        }).onCancel(() => {
          // console.log('Cancel')
        }).onDismiss(() => {
          // console.log('I am triggered on both OK and Cancel')
        })
      },
    },
    components: {
      NewCategory,
      EditCategory,
      Notify
    }
	}
</script>

<style>
  .category-description {
    font-size: 0.85em;
    font-style: italic;
    max-width: 400px;
    /*width: auto;*/
    /*overflow: hidden;*/
    /*text-overflow: ellipsis;*/
    white-space: normal;
    color: #555;
    margin-top: 4px;
  }
</style>