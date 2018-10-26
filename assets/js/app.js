// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import jQuery from 'jquery';
window.jQuery = window.$ = jQuery; // Bootstrap requires a global "$" object.
import "bootstrap";
import _ from "lodash";

$(function() {
  function load_time_blocks(task_id) {
    $.ajax(`/ajax/time_blocks/?task_id=${task_id}`, {
      method: "get",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: "",
      success: (resp) => {
        _.each(resp.data, function(val) {
	  $('#time-list').append(`<li>#{val.username}: #{val.start} -> #{val.end}</li>`);
	});
      },
     });
  }

  // can get rid of and just use the form submit, maybe
  $('#add-time-block').click((ev) => {
    let start_date = $('#start-date').val();
    let start_time = $('#start-time').val();
    let end_date = $('#end-date').val();
    let end_time = $('#end-time').val();
    let task_id = $(ev.target).data('task-id');
    let user_id = $(ev.target).data('user-id');
    
    let data = JSON.stringify({
      time_block: {
        user_id: parseInt(user_id),
	task_id: parseInt(task_id),
	start_date: start_date,
	start_time: start_time,
	end_date: end_date,
	end_time: end_time
      }
    });

    $.ajax(`/ajax/time_blocks/`, {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: data,
      success: (resp) => {
        window.location.replace(`/tasks/${task_id}`);
      },
     });
  });

  $('#delete-time-block').click((ev) => {
    let time_block_id = $(ev.target).data('time-block-id');
    let task_id = $(ev.target).data('task-id');

    $.ajax(`/ajax/time_blocks/${time_block_id}`, {
      method: "delete",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: "",
      success: (resp) => {
        window.location.replace(`/tasks/${task_id}`);
      },
     });
  });
  
  // NOTE: was tring to implement through Phoenix, but was not working out.
  // This approach was a bit better, but I am missing the CSRF.
  $('#remove-employee').click((ev) => {
    let username = $(ev.target).data('employee-username');
    let user_id = $(ev.target).data('user-id');

    let data = JSON.stringify({
      id: -1,
      username: username
    });

    $.ajax(`/users/-1`, {
      method: "put",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: data,
      success: (resp) => {
        window.location.replace(`/users/${user_id}`);
      },
     });
  }); 
});
