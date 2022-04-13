<template lang="pug">
  div
    div(v-if="loading")
      q-page-container(align="middle")
        q-spinner(color="primary" size="7em" :thickness="10")
    div(v-else)
      div(v-if="error")
        p Error!
      div(v-else)
        div
          q-carousel(
            animated
            v-model="slide"
            :autoplay="autoplay"
            infinite
            arrows
            padding
            transition-prev="scale"
            transition-next="scale"
            control-color="primary"
            height="323px"
            class="bg-white text-primary"
            )
            q-carousel-slide(:name="1" class="column no-wrap flex-center")
              div(class="row fit justify-end items-center q-gutter-xs q-col-gutter no-wrap")
                q-item(align="left")
                  q-item-section
                    div(class="text-h3 text-green-7") "Там, где есть книга,
                    div(class="text-h5 text-grey-9") человек уже не остаётся наедине с самим собой, в четырех стенах своего кругозора, он приобщается ко всем свершениям прошлого и настоящего."©
                    div(class="text-h5 text-green-7" align="right") Стефан Цвейг
                q-img(:src="require('../images/slide_1.png')" class="full-height")
            q-carousel-slide(:name="2" class="column no-wrap flex-center")
              div(class="row fit justify-between items-center q-gutter-xs q-col-gutter no-wrap")
                q-img(:src="require('../images/slide_2 (left).png')" class="full-height")
                q-item(align="left")
                  q-item-section
                    div(class="text-h3 text-light-blue-8") "Все хорошие книги,
                    div(class="text-h5 text-grey-9") сходны в одном, - когда вы дочитаете до конца, вам кажется, что все это случилось с вами, и так оно при вас и останется: хорошее или плохое, восторги, печали и сожаления, люди и места, и какая была погода."©
                    div(class="text-h5 text-light-blue-8" align="right") Эрнест М. Хемингуэй
                q-img(:src="require('../images/slide_2 (right).png')"  class="full-height")
            q-carousel-slide(:name="3" class="column no-wrap flex-center")
              div(class="row fit justify-start items-center q-gutter-xs q-col-gutter no-wrap")
                q-img(:src="require('../images/slide_3.png')"  class="full-height")
                q-item(align="right")
                  q-item-section
                    div(class="text-h3 text-orange-10") "Скажи, что ты читаешь,
                    div(class="text-h5 text-grey-9") и я скажу, кто ты", - это верно. Но я лучше узнаю тебя, если ты скажешь, что ты перечитываешь.©
                    div(class="text-h5 text-orange-10" align="right") Франсуа Мориак

          q-toolbar(class="bg-green-3")
            q-toolbar-title(align="middle") Новинки
          div(class="fit no-wrap q-pa-md row justify-center q-gutter-sm")
            q-intersection(v-for="book in new_data", :key="book", class="card", once, transition="scale")
              q-card
                q-img(:src="book.image_src", clickable, class="scale", @click="showBook(book)")
                  q-badge(color="green" floating) NEW
                  div(class="absolute-bottom text-body1 text-center") {{ book.title }}
                  q-tooltip(:delay="700" anchor="center right" self="center left" content-style="font-size: 12px")
                    div(class="text-h6") {{ book.title }}
                    div(class="text-body2") {{ book.short_description }}

          q-toolbar(class="bg-blue-3")
            q-toolbar-title(align="middle") Популярные книги
          div(class="fit no-wrap q-pa-md row justify-center q-gutter-sm")
            q-intersection(v-for="book in popular_data", :key="book", class="card", once, transition="scale")
              q-card
                q-img(:src="book.image_src", clickable, class="scale", @click="showBook(book)")
                  q-badge(color="blue" floating) HIT
                  div(class="absolute-bottom text-body1 text-center") {{ book.title }}
                  q-tooltip(:delay="700" anchor="center right" self="center left" content-style="font-size: 12px")
                    div(class="text-h6") {{ book.title }}
                    div(class="text-body2") {{ book.short_description }}

          q-toolbar(class="bg-orange-3")
            q-toolbar-title(align="middle") Лучшие оценки
          div(class="fit no-wrap q-pa-md row justify-center q-gutter-sm")
            q-intersection(v-for="book in top_data", :key="book", class="card", once, transition="scale")
              q-card
                q-img(:src="book.image_src", clickable, class="scale", @click="showBook(book)")
                  q-badge(color="orange" floating) {{ book.calculate_rating }}
                    q-icon(name="star")
                    //q-rating(readonly, size="1.5em", color="orange", icon="star_border", icon-selected="star" v-model="book.current_rating")
                  div(class="absolute-bottom text-body1 text-center") {{ book.title }}
                  q-tooltip(:delay="700" anchor="center right" self="center left" content-style="font-size: 12px")
                    div(class="text-h6") {{ book.title }}
                    div(class="text-body2") {{ book.short_description }}

          q-toolbar(class="bg-grey-4")
            q-toolbar-title(align="middle") Самые обсуждаемые
          div(class="fit no-wrap q-pa-md row justify-center q-gutter-sm")
            q-intersection(v-for="book in commented_data", :key="book", class="card", once, transition="scale")
              q-card
                q-img(:src="book.image_src", clickable, class="scale", @click="showBook(book)")
                  q-badge(color="grey" floating) {{ book.comments_count }}
                    q-icon(name="chat_bubble_outline")
                  div(class="absolute-bottom text-body1 text-center") {{ book.title }}
                  q-tooltip(:delay="700" anchor="center right" self="center left" content-style="font-size: 12px")
                    div(class="text-h6") {{ book.title }}
                    div(class="text-body2") {{ book.short_description }}
        router-view(@add-comment="fetchBooks" @add-vote="fetchBooks")

</template>

<script>
  import { getBooks } from '../api'
  import ShowBook from './BooksForm/ShowBook'

  export default {
    data() {
      return {
        slide: 1,
        autoplay: true,
        new_data: [],
        popular_data: [],
        top_data: [],
        commented_data: [],
        loading: true,
      }
    },
    created() {
      this.fetchBooks();
    },
    methods: {
      fetchBooks() {
        getBooks({ filter: 'new' })
            .then((response) => {
              // this.new_data = response.data.books
              this.new_data = response.data.data.map(i => i.attributes);
            })
            .catch((error) => {
              console.log(error);
              this.error = true
            })
            .finally(() => {
              this.loading = false
            });
        getBooks({ filter: 'popular' })
            .then((response) => {
              // this.popular_data = response.data.books
              this.popular_data = response.data.data.map(i => i.attributes);
            })
            .catch((error) => {
              console.log(error);
              this.error = true
            })
            .finally(() => {
              // this.loading = false
            });
        getBooks({ filter: 'top' })
            .then((response) => {
              // this.top_data = response.data.books
              this.top_data = response.data.data.map(i => i.attributes);
            })
            .catch((error) => {
              console.log(error);
              this.error = true
            })
            .finally(() => {
              // this.loading = false
            });
        getBooks({ filter: 'commented' })
            .then((response) => {
              // this.commented_data = response.data.books
              this.commented_data = response.data.data.map(i => i.attributes);
            })
            .catch((error) => {
              console.log(error);
              this.error = true
            })
            .finally(() => {
              // this.loading = false
            });
      },
      showBook(book) {
        this.$router.push({ name: 'showBookIndex', params: { id: book.id } })
      },
    },
    components: {
      ShowBook
    }
  }
</script>

<style>
  .scale {
    transition: 1s;
  }
  .scale:hover {
    box-shadow: 0 0 5px;
    transform: scale(1.2);
    z-index: 10;
  }
  .slider {
    text-align: right;
    padding: 24px;
    color: white;
    background-color: rgba(0, 0, 0, .3)
  }
  .title-book {
    text-align: center;
    padding: 12px;
    color: white;
    background-color: rgba(0, 0, 0, .3)
  }
  .card {
    width: 200px;
    height: 323px
  }
</style>
