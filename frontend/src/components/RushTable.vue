<template>
  <v-container class="mt-4">
    <v-row class="text-center">
      <v-col cols="12">
        <v-card>
          <v-card-title>
            Players
            <v-spacer></v-spacer>
            
            <small class="mt-4 mr-2">Sort by</small>
            <v-btn
              :color="sort_by_selected === 'Yds' ? 'warning' : 'info'"
              class="mt-4 mr-2"
              small
              @click="sort_by('Yds')"
              >
              Yds
            </v-btn>
            <v-btn
              :color="sort_by_selected === 'Lng' ? 'warning' : 'info'"
              class="mt-4 mr-2"
              small
              @click="sort_by('Lng')"
              >
              Lng
            </v-btn>
            <v-btn
              :color="sort_by_selected === 'TD' ? 'warning' : 'info'"
              class="mt-4 mr-5"
              small
              @click="sort_by('TD')"
              >
              TD
            </v-btn>
            
            <v-btn
              class="mt-4 mx-5"
              small
              @click="on_export"
              >
              Export
            </v-btn>

            <form class="ml-5" @submit.prevent="on_search">
              <v-text-field
                v-model="search"
                append-icon="fas fa-search"
                label="Search by Name"
                single-line
                hide-details
                clearable
                style="width:400px"
                @click:clear="on_clear_search"
              ></v-text-field>
            </form>
          </v-card-title>

          <v-data-table
            :headers="headers"
            :items="items"
            :items-per-page="10"
            class="elevation-1"
            disable-sort
            disable-pagination
            hide-default-footer
            :loading="loading"
            loading-text="Loading... Please wait"
          ></v-data-table>

          <br>
          <small>Page {{page}}</small>
          <br>
          <v-btn
            color="primary"
            class="mt-2 mb-4 mx-2"
            @click="previous_page"
            :disabled="page === 1"
            >
            Previous Page
          </v-btn>
          <v-btn
            color="primary"
            class="mt-2 mb-4 mx-2"
            @click="next_page"
            :disabled="page * size >= total"
            >
            Next Page
          </v-btn>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
  import axios from 'axios';

  export default {
    data () {
      return {
        headers: [
          { text: 'Name', value: 'name', sortable: true },
          { text: 'Team', value: 'team_abv', sortable: false },
          { text: 'Postion', value: 'postion', sortable: false },
          { text: 'Att/G', value: 'attempts_per_game_avg', sortable: false },
          { text: 'Attempts', value: 'attempts', sortable: false },
          { text: 'Yds', value: 'total_yards', sortable: false },
          { text: 'Avg', value: 'avg_yards_per_attempt', sortable: false },
          { text: 'Yds/G', value: 'yards_per_game', sortable: false },
          { text: 'TD', value: 'total_touchdowns', sortable: true },
          { text: 'Lng', value: 'longest_rush', sortable: false },
          { text: '1st', value: 'first_downs', sortable: false },
          { text: '1st%', value: 'first_down_percent', sortable: false },
          { text: '20+', value: 'more_20_yards', sortable: false },
          { text: '40+', value: 'more_40_yards', sortable: false },
          { text: 'FUM', value: 'fumbles', sortable: false },
        ],
        items: [],
        loading: false,
        search: null,
        page: 1,
        size: 10,
        total: 0,
        sort_by_selected: null
      }
    },
    mounted() {
      this.fetch_players()
    },
    methods: {
      on_clear_search() {
        this.search = null
        this.sort_by_selected = null
        this.page = 1
        this.fetch_players()
      },
      on_search(){
        this.sort_by_selected = null
        this.page = 1
        this.fetch_players()
      },
      sort_by(key) {
        this.search = null
        this.sort_by_selected = this.sort_by_selected === key ? null : key
        this.page = 1
        this.fetch_players()
      },
      previous_page() {
        this.page = (this.page - 1) > 0 ? this.page - 1 : 1
        this.fetch_players()
      },
      next_page() {
        this.page++
        this.fetch_players()
      },
      fetch_players(){
        const url = this.search
          ? `http://localhost:4000/api/players/${this.search}`
          : `http://localhost:4000/api/players`
        
        this.loading = true

        axios.get(url, {
          params: {
            order_by: this.sort_by_selected,
            page: this.page,
            size: this.size
          }
        }).then((response) => {
          this.loading = false
          this.items = response.data.result
          this.total = response.data.total
        })
        .catch((error) => {
          console.log(error);
          this.items = []
          this.total = 0
          this.loading = false
        })
      },
      on_export() {
        axios.post(`http://localhost:4000/api/players/generate_csv`, {})
          .then((response) => {
            console.log(response.data)
            window.open(`file://${response.data.filepath}`)
          })
          .catch((error) => {
            console.log(error);
          });
      },
      on_export_blob() {
        axios.get(`http://localhost:4000/api/players/generate_csv`, { responseType: 'blob' })
          .then((response) => {
            new File([response.data], 'data.csv');
          })
          .catch((error) => {
            console.log(error);
          });
      }
    },
  }
</script>
