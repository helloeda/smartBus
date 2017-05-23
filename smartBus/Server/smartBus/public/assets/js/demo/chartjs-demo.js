$(function () {

    var lineData = {
        labels: ["黄龙公交站","九莲新村","天目山路学","古荡","丰潭路南口","天目山路古","天目山路紫","汽车西站","西溪湿地高庄","西溪湿地周","留下北","留下西","西溪医院横街","屏峰","水口","上埠","头山门","浙江科技学院","冲天庙","石马社区","四喜凉亭","午潮山北","童家头","清家坞","洞山","里山桥"],
        datasets: [
            {
                label: "Example dataset",
                fillColor: "rgba(226,179,148,0.5)",
                strokeColor: "rgba(226,179,148,0.7)",
                pointColor: "rgba(226,179,148,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(226,179,148,1)",
                data: [35, 29, 15, 22, 16, 25, 30, 25, 29, 30, 40, 26, 15, 30, 25, 39, 12, 24, 16, 39, 38, 39, 20, 40, 21, 31, 32, 20]
            },
            {
                label: "Example dataset",
                fillColor: "rgba(26,179,148,0.5)",
                strokeColor: "rgba(26,179,148,0.7)",
                pointColor: "rgba(26,179,148,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(26,179,148,1)",
                data: [15, 19, 10, 21, 26, 35, 40, 15, 19, 10, 21, 26, 35, 40, 15, 19, 10, 21, 26, 35, 40, 15, 19, 10, 21, 26, 35, 40]
            }
        ]
    };

    var lineOptions = {
        scaleShowGridLines: true,
        scaleGridLineColor: "rgba(0,0,0,.05)",
        scaleGridLineWidth: 1,
        bezierCurve: true,
        bezierCurveTension: 0.4,
        pointDot: true,
        pointDotRadius: 4,
        pointDotStrokeWidth: 1,
        pointHitDetectionRadius: 20,
        datasetStroke: true,
        datasetStrokeWidth: 2,
        datasetFill: true,
        responsive: true,
    };


    var ctx = document.getElementById("lineChart").getContext("2d");
    var myNewChart = new Chart(ctx).Line(lineData, lineOptions);

});