(function () {
    $(document).ready(function () {
        init_post();
    });
})()
function init_post() {
    bind_menu_event();
}

function bind_menu_event() {
    $(".post-menu-a[pin=false]").click(function () {

        var post_list = $(this);


        var menu_type = $(this).attr('type');

        post_manager.list($("#course").attr("course"), menu_type, function (data) {
            post_list.next('div').html(data);
        });

    });

    $('body').on('click', ".post-menu-item-a", function () {
        var target = $(this);
        post_manager.show($(this).attr('id'), function (data) {
            $("#post-content").html(data);
        });
    });
}

function comment() {

    var post_id = $("#post").attr("post")
    var content = $("#comment").val();

    var data = {
        comment: {
            post_id: post_id,
            content: content
        }
    }

    comment_manager.create(data, function (data) {
        if (data.result) {

        } else {

        }
    })
}

function create_post() {
    var title = $("#title").val();
    var content = $("#content").val();
    var id = $("#course").attr("course");
    var data = {
        id: id,
        post: {
            title: title,
            content: content
        }
    }
    var attachs = get_attach();

    data.attachs = attachs;

    posts_manager.create(data, function (data) {
        if (data.result) {
            MessageBox("新建帖子成功", "top", "success");
        } else {
            MessageBox_content(data.content)
        }
    })
}