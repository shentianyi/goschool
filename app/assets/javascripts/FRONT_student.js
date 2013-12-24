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
    $("body").on("click","[name='upload-file']",function(){
        $("#upload-my-home-work").css("left","0px").css("right","0px")
        $("#student-homework-submit-button").attr("homework",$(this).attr("homework"));
    });
    $("body").on("click",".homework-post-add>.inner>.remove",function(){
        $(".homework-post-add input,.homework-post-add textarea").val("");
        $(".homework-post-add").css("left","-999em").css("right","auto");
        $("#task-attach-uploader-preview").empty();
    });
    $(document).ready(function(){
        //post(得到的数组放到下面的对象中就可以了)
        $.get("/student_homeworks/submit_calculate",{id:$("#detail-content").attr("student")},function(data){
              STUDENT_FRONT.pie={
                    scores:data
              };
            HOMEWORKCHART.generatePie(STUDENT_FRONT.pie.scores,"homework-pie-wrap");
        });
        $("#homework-line-wrap .buttons .button").eq(0).click();
//        STUDENT_FRONT.line={
//            labels:["2013-01-03","2013-01-04","2013-01-05"],
//            scores:[15,18,19]
//        };
//        STUDENT_FRONT.pie={
//            scores:[20,21]
//        };
//        HOMEWORKCHART.generateLine(STUDENT_FRONT.line.labels,STUDENT_FRONT.line.scores,"homework-line-wrap");
//        HOMEWORKCHART.generatePie(STUDENT_FRONT.pie.scores,"homework-pie-wrap");
    });

    init_front_student();
})();
var STUDENT_FRONT=STUDENT_FRONT || {};
STUDENT_FRONT.check=0;

function init_front_student(){
    bind_sh_submit_event(function(data){
        if(data.result){
            MessageBox("提交作业成功!","top","success");
            var container = "li[homework="+data.content+"]";
            $("ul").find(container).remove();
        }
        else{
            MessageBox("提交作业失败!","top","warning");
        }
    });
}


