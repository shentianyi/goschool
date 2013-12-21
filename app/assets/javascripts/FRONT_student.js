(function(){
    $(window).resize(function(){
        STUDENT_FRONT.check++;
        window.setTimeout(function(){
            if(STUDENT_FRONT.check==1){
                HOMEWORKCHART.generateLine(STUDENT_FRONT.line.labels,STUDENT_FRONT.line.scores,"homework-line-wrap");
                HOMEWORKCHART.generatePie(STUDENT_FRONT.pie.scores,"homework-pie-wrap");
                STUDENT_FRONT.check--;
            }
            else{
                STUDENT_FRONT.check--;
            }
        },300);
    });
    var height=$("#student-homework").height();
    if(height>200){
        $("#student-homework").css("margin-bottom","200px");
    }
    $(document).ready(function(){
        //post(得到的数组放到下面的对象中就可以了)
        STUDENT_FRONT.line={
            labels:["2013-01-03","2013-01-04","2013-01-05"],
            scores:[15,18,19]
        };
        STUDENT_FRONT.pie={
            scores:[20,1]
        };
        HOMEWORKCHART.generateLine(STUDENT_FRONT.line.labels,STUDENT_FRONT.line.scores,"homework-line-wrap");
        HOMEWORKCHART.generatePie(STUDENT_FRONT.pie.scores,"homework-pie-wrap");
    });
})();
var STUDENT_FRONT=STUDENT_FRONT || {};
STUDENT_FRONT.check=0;

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
