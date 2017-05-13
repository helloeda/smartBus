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
Route::any('get/route/list', 'BusController@getRouteList');
Route::any('get/route/detail/{routeId?}', 'BusController@getRouteDetailById');

Route::any('get/stop/list', 'BusController@getStopList');
Route::any('get/stop/detail/{stopId?}', 'BusController@getStopDetailById');

Route::any('gps', 'BusController@setGps');

Route::any('get/current', 'BusController@getCurrent');


//Route::any('get/stop', 'BusController@getStop');