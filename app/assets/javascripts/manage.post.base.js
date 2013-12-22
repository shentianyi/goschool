(function(){
    $(document).ready(function(){
	init_post();
    });
})()
function init_post(){
    bind_menu_event();
}

function bind_menu_event(){
    $(".post-menu-a[pin=false]").click(function(){
	var post_list = $(this).next('div');
	var menu_type = $(this).attr('type');

	post_manager.list($("#course").attr("course"),menu_type,function(data){
	    post_list.html(data);
	});
    });

    $('body').on('click',".post-menu-item-a",function(){
	post_manager.show($(this).attr('id'),function(data){
	    $("#post-content").html(data); 
	});
    });
}

function comment(){
    var post_id = $("#post").attr("post")
    var content = $("#comment").val();

    var data = {
	comment:{
	    post_id:post_id,
	    content:content
	}
    }

    comment_manager.create(data,function(data){
	if(data.result){
	    
	}else
	{
	    
	}
    })
}