<!DOCTYPE html>
<html>

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>智慧交通管理后台</title>

    <link href="/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="/assets/font-awesome/css/font-awesome.css" rel="stylesheet">

    <link href="/assets/css/plugins/dataTables/datatables.min.css" rel="stylesheet">

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
                <h2>车辆列表</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="/admin/index">首页</a>
                    </li>
                    <li class="active">
                        <strong>车辆列表</strong>
                    </li>
                </ol>
            </div>
            <div class="col-lg-2">

            </div>
        </div>
        <div class="wrapper wrapper-content animated fadeInRight">

            <div class="row">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>公交车辆列表</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                                <a class="dropdown-toggle" data-toggle="dropdown" href="table_data_tables.html#">
                                    <i class="fa fa-wrench"></i>
                                </a>
                                <ul class="dropdown-menu dropdown-user">
                                    <li><a href="table_data_tables.html#">Config option 1</a>
                                    </li>
                                    <li><a href="table_data_tables.html#">Config option 2</a>
                                    </li>
                                </ul>
                                <a class="close-link">
                                    <i class="fa fa-times"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <div class="">
                                <a onclick="fnClickAddRow();" href="javascript:void(0);" class="btn btn-primary ">添加车辆</a>
                                <a onclick="fnClickAddRow();" href="javascript:void(0);" class="btn btn-primary ">自动更新</a>
                            </div>
                            <table class="table table-striped table-bordered table-hover " id="editable" >
                                <thead>
                                <tr>
                                    <th>车牌号</th>
                                    <th>驾驶员</th>
                                    <th>所属线路</th>
                                    <th>座位数</th>
                                    <th>修改时间</th>
                                </tr>
                                </thead>
                                <tbody>
                                @foreach ($res as $tmp)
                                    <tr class="gradeX">
                                        <td>{{$tmp->bus_no}}</td>
                                        <td>{{$tmp->bus_driver}}</td>
                                        <td>{{$tmp->route_name}}</td>
                                        <td class="center">{{$tmp->bus_capacity}}</td>
                                        <td class="center">{{$tmp->updated_at}}</td>
                                    </tr>
                                @endforeach
                                </tbody>
                            </table>

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
<script src="/assets/js/plugins/jeditable/jquery.jeditable.js"></script>

<script src="/assets/js/plugins/dataTables/datatables.min.js"></script>

<!-- Custom and plugin javascript -->
<script src="/assets/js/inspinia.js"></script>
<script src="/assets/js/plugins/pace/pace.min.js"></script>

<!-- Page-Level Scripts -->
<script>
    $(document).ready(function(){
        $('.dataTables-example').DataTable({
            dom: '<"html5buttons"B>lTfgitp',
            buttons: [
                { extend: 'copy'},
                {extend: 'csv'},
                {extend: 'excel', title: 'ExampleFile'},
                {extend: 'pdf', title: 'ExampleFile'},

                {extend: 'print',
                    customize: function (win){
                        $(win.document.body).addClass('white-bg');
                        $(win.document.body).css('font-size', '10px');

                        $(win.document.body).find('table')
                            .addClass('compact')
                            .css('font-size', 'inherit');
                    }
                }
            ]

        });

        /* Init DataTables */
        var oTable = $('#editable').DataTable();

        /* Apply the jEditable handlers to the table */
        oTable.$('td').editable( '../example_ajax.php', {
            "callback": function( sValue, y ) {
                var aPos = oTable.fnGetPosition( this );
                oTable.fnUpdate( sValue, 1, aPos[1] );
            },
            "submitdata": function ( value, settings ) {
                return {
                    "row_id": this.parentNode.getAttribute('id'),
                    "column": oTable.fnGetPosition( this )[2]
                };
            },

            "width": "90%",
            "height": "100%"
        } );


    });

    function fnClickAddRow() {
        $('#editable').dataTable().fnAddData( [
            "Custom row",
            "New row",
            "New row",
            "New row",
            "New row" ] );

    }
</script>

</body>

</html>
