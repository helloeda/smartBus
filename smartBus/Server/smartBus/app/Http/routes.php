<?php

/*
|--------------------------------------------------------------------------
| Routes File
|--------------------------------------------------------------------------
|
| Here is where you will register all of the routes in an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the controller to call when that URI is requested.
|
*/

Route::get('/', function () {
    return view('welcome');
});

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| This route group applies the "web" middleware group to every route
| it contains. The "web" middleware group is defined in your HTTP
| kernel and includes session state, CSRF protection, and more.
|
*/

Route::group(['middleware' => ['web']], function () {
    //
});


Route::any('add', 'AddController@add');

//iOS接口
Route::any('get/route/list', 'BusController@getRouteList');
Route::any('get/route/detail/{routeId?}', 'BusController@getRouteDetailById');
Route::any('get/stop/list', 'BusController@getStopList');
Route::any('get/stop/detail/{stopId?}', 'BusController@getStopDetailById');
Route::any('get/current/{routeId?}', 'BusController@getCurrent');

//硬件交互路由
Route::any('gps', 'BusController@setGps');


//管理端
Route::get('admin/show/bus', 'AdminController@showBus');
Route::get('admin/show/stop', 'AdminController@showStop');
Route::get('admin/show/route', 'AdminController@showRoute');
Route::get('admin/index', 'AdminController@index');

