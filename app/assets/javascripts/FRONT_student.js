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
        $.get("/student_homeworks/submit_calculate",{id:$("#detail-content").attr("student")},function(data){
              STUDENT_FRONT.pie={
                    scores:data
              };
            HOMEWORKCHART.generatePie(STUDENT_FRONT.pie.scores,"homework-pie-wrap");
        })
        STUDENT_FRONT.line={
            labels:["2013-01-03","2013-01-04","2013-01-05"],
            scores:[15,18,19]
        };
//        STUDENT_FRONT.pie={
//            scores:[20,21]
//        };
        HOMEWORKCHART.generateLine(STUDENT_FRONT.line.labels,STUDENT_FRONT.line.scores,"homework-line-wrap");
//        HOMEWORKCHART.generatePie(STUDENT_FRONT.pie.scores,"homework-pie-wrap");
    });
})();
var STUDENT_FRONT=STUDENT_FRONT || {};
STUDENT_FRONT.check=0;


