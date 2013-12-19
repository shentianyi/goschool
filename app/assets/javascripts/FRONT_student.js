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
    	}
    }
    posts_manager.create(data,function(data){
	if(data.result){
	    console.log("success");
	}else{
	    
	}
    })
}
