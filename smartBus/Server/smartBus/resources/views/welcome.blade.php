<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <style type="text/css">
        body, html, #allmap {
            width: 100%;
            height: 100%;
            overflow: hidden;
            margin: 0;
            font-family: "微软雅黑";
        }
    </style>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=QXwuA2Zi8h3huVQvqVrW2MhU"></script>
    <script type="text/javascript" src="http://developer.baidu.com/map/jsdemo/demo/convertor.js"></script>
    <script type="text/javascript" src="./jquery-3.1.1.min.js"></script>
    <title>野火GPS地图</title>
</head>
<body>
<div id="allmap"></div>



</body>
</html>



<script type="text/javascript">





    try {


        // 百度地图API功能
        var map = new BMap.Map("allmap");            // 创建Map实例

        //添加拖拽和缩放功能
        map.enableScrollWheelZoom(true);
        map.enableDragging();

        //添加控件和比例尺
        var top_right_control = new BMap.ScaleControl({ anchor: BMAP_ANCHOR_BOTTOM_LEFT });// 左下角，添加比例尺
        var top_right_navigation = new BMap.NavigationControl({ anchor: BMAP_ANCHOR_BOTTOM_LEFT });  //左下角，添加默认缩放平移控件

        map.addControl(top_right_control);
        map.addControl(top_right_navigation);


        //添加地图类型
        var mapType1 = new BMap.MapTypeControl({ mapTypes: [BMAP_NORMAL_MAP, BMAP_HYBRID_MAP] });
        var mapType2 = new BMap.MapTypeControl({ anchor: BMAP_ANCHOR_TOP_LEFT });

        //添加地图类型和缩略图

        map.addControl(mapType1);          //2D图，卫星图
        map.addControl(mapType2);          //左上角，默认地图控件




        //读取后端数据
        var jd,wd;
        $.ajax({
            type: "get",
            url: "/get/current",
            cache:false,
            async:false,
            dataType: "JSON",
            success: function(data){
                jd = data['message'][0]['current_longitude'];
                wd = data['message'][0]['current_latitude'];
            }
        });


        //创建点
        map.clearOverlays();
        var point = new BMap.Point(jd,wd);
        map.centerAndZoom(point, 12);
        var marker = new BMap.Marker(point);  // 创建标注
        map.addOverlay(marker);               // 将标注添加到地图中

        //根据IP定位城市
        function myFun(result) {
            var cityName = result.name;
            map.setCenter(cityName);
        }
        var myCity = new BMap.LocalCity();
        myCity.get(myFun);


        //showalert(testmsg);

        //对传入的经纬度进行标注：纬度，经度
        // var Latt = 116.404;
        // var Lott = 39.915;

        // theLocation(Latt, Lott);
        // testAlert();

        // 用经纬度设置地图中心点
        function theLocation(Longitude,Latitude) {

            var gpsPoint = new BMap.Point(Longitude, Latitude);

            //gps坐标纠偏
            BMap.Convertor.translate(gpsPoint, 0, translateCallback);     //真实经纬度转成百度坐标


            map.clearOverlays();
            var new_point = new BMap.Point(Longitude,Latitude);
            var marker = new BMap.Marker(new_point);  // 创建标注
            map.addOverlay(marker);              // 将标注添加到地图中
            map.panTo(new_point);
            marker.setAnimation(BMAP_ANIMATION_BOUNCE); //跳动的动画

        }


        // 用经纬度设置地图中心点
        function testAlert(msg) {

            var str = new String;
            str =  msg.toString()
            // str = "test"

            alert(str);
        }

        function enableZoomDrag()
        {
            //添加拖拽和缩放功能
            map.enableScrollWheelZoom(true);
            map.enableDragging();
        }


        //坐标转换完之后的回调函数
        translateCallback = function (point) {

            map.clearOverlays();
            var marker = new BMap.Marker(point);
            map.addOverlay(marker);
            map.setCenter(point);
            //  marker.setAnimation(BMAP_ANIMATION_BOUNCE); //跳动的动画
        }

    } catch (e) {

        alert("地图加载失败，请检查网络！");

    }
    theLocation(jd,wd);

</script>



