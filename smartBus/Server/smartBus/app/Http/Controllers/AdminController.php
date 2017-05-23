<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Http\Requests;

use Illuminate\Support\Facades\DB;

class AdminController extends Controller
{
    public function showBus()
    {

        $res = DB::table('bus')
            ->join('route', 'bus.bus_route', '=', 'route.route_id')
            ->select()->get();

        return view('showbus',['res' => $res]);
    }



    public function showStop()
    {

        $res = DB::table('stop')
            ->select()->get();

        return view('showstop',['res' => $res]);
    }



    public function showRoute()
    {

        $res = DB::table('route')
            ->select()->get();

        return view('showroute',['res' => $res]);
    }



    public function index()
    {

        $res = DB::table('route')
            ->select()->get();

        return view('index',['res' => $res]);
    }


}
