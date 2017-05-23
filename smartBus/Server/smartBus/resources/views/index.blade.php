<!DOCTYPE html>
<html>

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>智慧交通管理后台</title>

    <link href="/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="/assets/font-awesome/css/font-awesome.css" rel="stylesheet">

    <link href="/assets/css/plugins/dataTables/datatables.min.css" rel="stylesheet">
    <link href="/assets/css/plugins/datapicker/datepicker3.css" rel="stylesheet">

    <link href="/assets/css/animate.css" rel="stylesheet">
    <link href="/assets/css/style.css" rel="stylesheet">

</head>

<body>

<div id="wrapper">

    <nav class="navbar-default navbar-static-side" role="navigation">
        <div class="sidebar-collapse">
            <ul class="nav metismenu" id="side-menu">
                <li class="nav-header">
                    <div class="dropdown profile-element"> <span>
                            <img alt="image" class="img-circle" src="/assets/img/profile_small.jpg" />
                             </span>
                        <a data-toggle="dropdown" class="dropdown-toggle" href="table_data_tables.html#">
                            <span class="clear"> <span class="block m-t-xs"> <strong class="font-bold">Eda</strong>
                             </span> <span class="text-muted text-xs block">管理员 <b class="caret"></b></span> </span> </a>
                        <ul class="dropdown-menu animated fadeInRight m-t-xs">
                            <li><a href="login.html">注销</a></li>
                        </ul>
                    </div>
                    <div class="logo-element">
                        IN+
                    </div>
                </li>
                <li>
                    <a href="/admin/index"><i class="fa fa-table"></i> <span class="nav-label">首页</span></a>
                </li>
                <li>
                    <a href="/admin/show/bus"><i class="fa fa-diamond"></i> <span class="nav-label">车辆管理</span></a>
                </li>
                <li>
                    <a href="/admin/show/stop"><i class="fa fa-envelope"></i> <span class="nav-label">站点管理</span></a>
                </li>
                <li>
                    <a href="/admin/show/route"><i class="fa fa-th-large"></i> <span class="nav-label">路线管理</span></a>
                </li>
                <li>
                    <a href="/admin/show/notification"><i class="fa fa-flask"></i> <span class="nav-label">资讯管理</span></a>
                </li>
                <li>
                    <a href="/admin/show/route"><i class="fa fa-laptop"></i> <span class="nav-label">建议管理</span></a>
                </li>
            </ul>

        </div>
    </nav>

    <div id="page-wrapper" class="gray-bg">
        <div class="row border-bottom">
            <nav class="navbar navbar-static-top" role="navigation" style="margin-bottom: 0">
                <div class="navbar-header">
                    <a class="navbar-minimalize minimalize-styl-2 btn btn-primary " href="table_data_tables.html#"><i class="fa fa-bars"></i> </a>

                </div>
                <ul class="nav navbar-top-links navbar-right">
                    <li>
                        <span class="m-r-sm text-muted welcome-message">城市智慧交通后台管理系统</span>
                    </li>
                    <li class="dropdown">

                        <ul class="dropdown-menu dropdown-messages">
                            <li>
                                <div class="dropdown-messages-box">
                                    <a href="profile.html" class="pull-left">
                                        <img alt="image" class="img-circle" src="/assets/img/a7.jpg">
                                    </a>

                                </div>
                            </li>

                        </ul>
                    </li>


                    <li>
                        <a href="login.html">
                            <i class="fa fa-sign-out"></i> Log out
                        </a>
                    </li>
                </ul>

            </nav>
        </div>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-lg-10">
                <h2>公交数据报表</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="/admin/index">首页</a>
                    </li>
                    <li class="active">
                        <strong>数据报表</strong>
                    </li>
                </ol>
            </div>
            <div class="col-lg-2">

            </div>
        </div>
        <div class="wrapper wrapper-content animated fadeInRight">

            <div class="col-lg-14">
                <div class="ibox float-e-margins">
                    <div class="col-lg-8">
                        <div class="col-sm-6">
                            <div class="search-form">

                                <div class="input-group">
                                    <input id="date_added" type="text" class="form-control" value="2017/06/02">
                                    <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                                    <input align="right" type="text" placeholder="193路" class="form-control" name="top-search" id="top-search">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="ibox-title">
                        <div  align="right">
                            <small>小和山公交站→黄龙:</small>
                            <a style="color:rgba(226,179,148,1);">▇</a>
                        </div>

                        <div  align="right">
                            <small>黄龙→小和山公交站:</small>
                            <a style="color:rgba(26,179,148,1);">▇</a>
                        </div>

                    </div>
                    <div class="ibox-content">
                        <div>
                            <canvas id="lineChart" height="80"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer">
            <div>
                <strong>Copyright</strong> Hello Eda &copy; 2014-2015
            </div>
        </div>

    </div>
</div>




<!-- Mainly scripts -->
<script src="/assets/js/jquery-2.1.1.js"></script>
<script src="/assets/js/bootstrap.min.js"></script>
<script src="/assets/js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script src="/assets/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

<!-- Custom and plugin javascript -->
<script src="/assets/js/inspinia.js"></script>
<script src="/assets/js/plugins/pace/pace.min.js"></script>

<!-- ChartJS-->
<script src="/assets/js/plugins/chartJs/Chart.min.js"></script>
<script src="/assets/js/demo/chartjs-demo.js"></script>
<!-- Page-Level Scripts -->
<script src="/assets/js/plugins/datapicker/bootstrap-datepicker.js"></script>


<script>
    $(document).ready(function(){
        $('#date_added').datepicker({
            todayBtn: "linked",
            keyboardNavigation: false,
            forceParse: false,
            calendarWeeks: true,
            autoclose: true
        });

    });
    $( function() {
        $( "#date_added" ).datepicker();
    } );
</script>

</body>

</html>
