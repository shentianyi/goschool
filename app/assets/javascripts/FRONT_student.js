(function(){
    $(document).ready(function(){
        
    });
})()

function create_post(){
    var title = $("#title").val();
    var content = $("#content").val();
    var id = $("#course").attr("course");

    var data = {
    	id:id,
    	post:{
    	    title:title,
    	    content:content
    	},
    }
    
    var attachs = [];
    var length = $("#task-attach-uploader-preview").children().length;
    for(var i = 0;i<length;i++){
	attachs[i] = {};
	attachs[i].oriName = $("#task-attach-uploader-preview >div").eq(i).attr("title");
	attachs[i].pathName = $("#task-attach-uploader-preview >div").eq(i).attr("path-name")
    }
    
    data.attachs = attachs;

    posts_manager.create(data,function(data){
	if(data.result){
	    MessageBox("新建帖子成功","top","success");
	}else{
	    MessageBox_content(data.content)
	}
    })
}
