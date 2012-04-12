var Groups = {};
Groups.Search = {};

Groups.initialize = function () {
  this.Search.initialize();
}

Groups.Search.initialize = function () {
  this.searchResults = $("div#search_groups_results");
  this.searchInput = $("input#search_groups_text_input");
  this.serviceUrl = "groups/index";
}

Groups.Search.replaceSearchResults = function (newResults) {
  this.searchResults.html(newResults);
}

Groups.Search.removeSearchRecords = function () {
  $('div.group_list_element', this.searchResults).detach();
}

Groups.Search.addSearchRecord = function (record) {
  this.searchResult.append(record);
}

Groups.search.executeQuery = function (query, page, callback) {
  $.ajax(this.serviceUrl, {
    params: {
      query: query,
      page: page
    },
    success: this.queryHandler
  });
}

Groups.search.queryHandler = function (data) {
  eval(data); 
}

$(document).ready(function () {
  Groups.initialize();
});
