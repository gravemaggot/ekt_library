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
        q-toolbar(class="bg-green-2")
          q-toolbar-title(align="middle") Отчет по прочитанным книгам 
        div(class='q-pa-md')
          q-table(
            separator="cell"
            name="books",
            :title="title",
            :data="data",
            :loading="loading"
            :filter="filter",
            :columns="columns",
            :pagination.sync="pagination",
            :rows-per-page-options="[10, 25, 100]",
            binary-state-sort,
            row-key="id"
            no-data-label="НЕТ ЗАПИСЕЙ")
            template(v-slot:top="props")
              // Поиск
              div(style="width: 250px; max-width: 400px")
                q-input(debounce="300" v-model="filter" label="Общий поиск")
                  template(v-slot:append)
                    q-icon(v-if="filter !== ''" name="close" @click="filter = ''" class="cursor-pointer")
                    q-icon(name="search")
              q-space
              // Отбор по дате
              div(style="min-width: 150px; max-width: 600px")
                q-chip(outline square size="16px" clickable color="primary" text-color="white" icon="event")
                  | Период прочтения: {{ period.from }} - {{ period.to }}
                  q-popup-proxy(ref="qDateProxy" transition-show="scale" transition-hide="scale")
                    q-date(v-model="period" range)
                q-icon(
                  v-if="period !== ''"
                  name="cancel"
                  @click="period = ''"
                  size="md"
                  class="cursor-pointer text-primary")
              q-space
              // Экспорт  
              q-btn(
                color="primary"
                icon-right="archive"
                label="Экспорт в csv"
                no-caps
                @click="exportTable")
            template(v-slot:body-cell-book="props")
              q-td(align="center")
                | {{ props.row.title_book }}
            template(v-slot:body-cell-author="props")
              q-td(align="center")
                | {{ props.row.author_book }}
            template(v-slot:body-cell-user="props")
              q-td(align="center")
                | {{ props.row.user_name }}
            //- template(v-slot:body-cell-start_date="props")
            //-   q-td(align="center")
            //-     | {{ props.row.start_date }}
            template(v-slot:body-cell-end_date="props")
              q-td(align="center")
                | {{ props.row.end_date }}
</template>

<script>
  import { indexPosts } from '../../../api'
  import { Notify } from 'quasar'

  import { exportFile } from 'quasar'

  function wrapCsvValue (val, formatFn) {
    let formatted = formatFn !== void 0
      ? formatFn(val)
      : val

    formatted = formatted === void 0 || formatted === null
      ? ''
      : String(formatted)

    formatted = formatted.split('"').join('""')
    /**
     * Excel accepts \n and \r in strings, but some other CSV parsers do not
     * Uncomment the next two lines to escape new lines
     */
    // .split('\n').join('\\n')
    // .split('\r').join('\\r')

    return `"${formatted}"`
  }

  export default {
    data() {
      return {
        columns: [
          { name: 'id', align: 'left', label: 'ID', field: 'id', sortable: true },
          // { name: 'title', align: 'left', label: 'Title', field: 'title', sortable: true },
          { name: 'book', label: 'Наименование книги', align: 'center', field: row => row.title_book, sortable: true },
          { name: 'author', align: 'left', label: 'Автор', field: row => row.author_book, sortable: true },
          { name: 'user', label: 'Пользователь', align: 'center', field: row => row.user_name, sortable: true },
          // { name: 'start_date', align: 'left', label: 'Start', field: 'start_date', sortable: true },
          { name: 'end_date', align: 'left', label: 'Дата прочтения', field: row => row.end_date, sortable: true },
        ],
        data: [],
        title: '',
        filter: '',
        period: '',
        loading: true,
        ratingModel: 3,
        pagination: {
          rowsPerPage: 50
        },
      }
      // error: {}
    },
    computed: {
      user: {
        get() {
          return this.$store.state.currentUser
        }
      }
    },
    created() {
      this.fetchPosts();
    },
    watch: {
      period() {
        if (this.period !== '') {
          var startDate = new Date(this.period.from);
          var endDate = new Date(this.period.to);

          this.data = this.data.filter(item => {
            var end_date = new Date(item.end_date);
            return end_date >= startDate && end_date <= endDate;
          });
        } else {
          this.fetchPosts();
        }
      }
    },
    methods: {
      fetchPosts() {
        indexPosts()
            .then((response) => {
              console.log(response.data)
              this.data = response.data.data.map(i => i.attributes);
            })
            .catch((error) => {
              console.log(error);
              this.error = true
            })
            .finally(() => {
              this.loading = false
            });
      },
      exportTable () {
        // naive encoding to csv format
        const content = [ this.columns.map(col => wrapCsvValue(col.label)) ].concat(
          this.data.map(row => this.columns.map(col => wrapCsvValue(
            typeof col.field === 'function'
              ? col.field(row)
              : row[col.field === void 0 ? col.name : col.field],
            col.format
          )).join(','))
        ).join('\r\n')

        const status = exportFile(
          'table-export.csv',
          content,
          'text/csv'
        )

        if (status !== true) {
          this.$q.notify({
            message: 'Browser denied file download...',
            color: 'negative',
            icon: 'warning'
          })
        }
      }
    },
    components: {
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
