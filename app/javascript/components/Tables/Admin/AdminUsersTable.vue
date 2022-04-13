<template lang="pug">
  div
    //- div(v-if="loading")
    //-   q-page-container(align="middle")
    //-     q-spinner(color="primary" size="7em" :thickness="10")
    //- div(v-else)
    div(v-if="error")
      p Error!
    div(v-else)
      div(v-if="user.admin == true")
        q-page-sticky(expand position="top")
          q-toolbar(class="bg-negative glossy text-white")
            q-toolbar-title(align="middle")
              | Пользователи(АДМИНИСТРИРОВАНИЕ)
        div(class='q-pa-md')
          q-table(
            name="users",
            :title="title",
            :data="data",
            :filter="filter"
            :loading="loading"
            :columns="columns",
            :pagination.sync="pagination",
            :rows-per-page-options="[10, 25, 100]",
            row-key="id"
            binary-state-sort,
            :visible-columns="visibleColumns"
            no-data-label="Нет информации о пользователях!")
            template(v-slot:body-cell-action="props")
              q-td(align="right")
                q-btn-group(flat)
                  q-btn(flat color="white" text-color="secondary" size="12px" icon="edit" label="Просмотр"  @click="editUser(props.row)")
                  //q-btn(flat color="white" text-color="negative" size="12px" icon="delete_forever" label="Удалить"  @click="deleteUser(props.row)" method="delete")
            template(v-slot:top="props")
              div(style="width: 250px; max-width: 400px")
                q-input(debounce="300" v-model="filter" label="Поиск")
                  template(v-slot:append)
                    q-icon(v-if="filter !== ''" name="close" @click="filter = ''" class="cursor-pointer")
                    q-icon(name="search")
              q-space
              q-select(
                v-model="visibleColumns"
                multiple
                outlined
                dense
                options-dense
                display-value="Колонки"
                emit-value
                map-options
                :options="columns"
                option-value="name"
                options-cover
                style="min-width: 250px"
              )
              q-space
              q-toggle(
                  ref="deactivated"
                  v-model="only_active"
                  label="Показывать только активных"
                  val="true"
                )
          q-page-sticky(position="bottom-left" :offset="[18, 18]")
            q-btn(fab color="primary" @click="newUser()" icon="add" name="Новый пользователь")
        router-view(@add-user="fetchUsers" @edit-user="fetchUsers")
</template>

<script>
	import { getUsers, deleteUser } from '../../../api'
  import NewUser from '../../UsersForm/CreateUser'
  import EditUser from '../../UsersForm/EditUser'
  import { Notify } from 'quasar'

  export default {
		data() {
			return {
        filter: '',
        visibleColumns: [ 'id', 'last_name', 'first_name', 'email', 'admin', 'booking_count', 'reading_count', 'deactivated', 'date_of_deactivation', 'crated_at', 'action' ],
				columns: [
          { name: 'id',                         label: 'ID',                align: 'left',    field: 'id',          sortable: true },
          { name: 'last_name',  label: 'Фамилия',           align: 'left',    field: 'last_name',   sortable: true },
          { name: 'first_name', label: 'Имя',               align: 'left',    field: 'first_name',  sortable: true },
          { name: 'email',      label: 'Email',             align: 'left',    field: 'email',       sortable: true },
          { name: 'admin',      label: 'Администратор',     align: 'center',  field: 'admin',       sortable: true },
          { name: 'booking_count',      label: 'Резерв',     align: 'center',  field: 'booking_count',       sortable: true },
          { name: 'reading_count',      label: 'Читает',     align: 'center',  field: 'reading_count',       sortable: true },
          { name: 'deactivated',      label: 'Заблокирован?',     align: 'center',  field: 'deactivated',       sortable: true },
          { name: 'date_of_deactivation',      label: 'Дата блокировки',     align: 'center',  field: 'date_of_deactivation',       sortable: true },
					{ name: 'crated_at',                  label: 'Создано',           align: 'center',  field: 'create_date', sortable: true },
					{ name: 'action',                     label: 'Кнопки управления', align: 'center',  field: ['edit', 'delete'] }
        ],
				data: [],
        pagination: {
          rowsPerPage: 50
        },
				title: '',
        only_active: false,
				loading: true,
        error: false
			}
		},
    computed: {
      user: {
        get() {
          return this.$store.state.currentUser
        }
      }
    },
    created() {
			this.fetchUsers();
		},
    watch: {
      only_active() {
        if (this.only_active == true) {

          this.data = this.data.filter(item => {
            return item.deactivated == false
          });
        } else {
          this.fetchUsers();
        }
      }
    },
    methods: {
			fetchUsers() {
				getUsers()
					.then((response) => {
						this.data = response.data.users
					})
					.catch((error) => {
						console.log(error);
						this.error = true
					})
					.finally(() => {
						this.loading = false
					});
      },
      newUser() {
				this.$router.push({ name: 'createUser'})
      },
      editUser(user) {
        this.$router.push({ name: 'editUser', params: { id: user.id } })
      },
      // deleteUser(user) {
      //   this.$q.dialog({
      //     title: "Удалить пользователя '" + user.email + "' ?",
      //     message: "Вы собираетесь безвозвратно удалить пользователя '" + user.first_name + " " + user.last_name + "' !",
      //     ok: {
      //       outline: true,
      //       color: 'negative',
      //       label: 'Да'
      //     },
      //     cancel: {
      //       flat: true,
      //       color: 'black',
      //       label: 'Нет'
      //     }
      //   }).onOk(() => {
      //     deleteUser(user.id)
      //       .then((response) => {
      //         this.fetchUsers();
      //         Notify.create({
      //           message: "Пользователь '" + user.email + "' удален!",
      //           color: 'negative'
      //         })
      //       })
      //       .catch((error) => {
      //         console.log(error);
      //         this.error = true
      //       });
      //   }).onCancel(() => {
      //     // console.log('Cancel')
      //   }).onDismiss(() => {
      //     // console.log('I am triggered on both OK and Cancel')
      //   })
      // },
    },
    components: {
      NewUser,
      EditUser,
      Notify
    }
	}
</script>

<style>
  .book-description {
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
