$(document).ready(function(){
  var refreshPosts = function(){
    $.get("/clients", function(data){
      $('#posts').html("");
      for (var i = 0; i < data.length; i++) {
        var id = data[i].id;
        $('#posts').prepend("<li data-id=" + data[i].id + ">" + "<span class='link'>" +  data[i].title + "</span></li> <hr>" );
      }
    });
  };


  $('#posts').on('click', 'span', function(){
    $('#posts').html('');
    var postId = $(this).parent().data('id');

    $.get('/clients/' + postId, function(data){
      var comments = data.comments;
      var postId = $(this).parent().data('id');
      var commentString = '';

      for (var i = 0; i < comments.length; i++) {
        commentString += comments[i].body + "<hr>";
      }


      $('#posts').html("<div data-id=" + postId + "><div class='link'>Back to posts</div>" + "<h1>" + data.title + "</h1> <br>" + data.body + commentString + commentForm + "</div>");
      $('.link').click(refreshPosts);
    });
  });
  var commentForm = "<form><h2>Create A Comment</h2><textarea rows='10' cols='110' id='body' placeholder='Enter your comment....'></textarea><br><span class='btn btn-large btn-primary'>Create Comment</span></form>";

  $('#posts').on('click', '.btn', function(){
    console.log('clicked!');
    var body = $('#body').val();
    $('#body').val('');
    var postId = $(this).parent().parent().data('id');
    $.post('/posts/' + postId + '/comments', {comment: {body: body}});
  });
  refreshPosts();

});
