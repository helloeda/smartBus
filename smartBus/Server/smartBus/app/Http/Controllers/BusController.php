<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Http\Requests;
use \Curl\Curl;
use Illuminate\Support\Facades\DB;
use Psy\Util\Json;
use App\Models\LEResult;

class BusController extends Controller
{

    public function getRouteList() {
        $res = DB::table('route')->select('route_id','route_name')->get();

        $result = new LEResult();
        if (!empty($res))
        {
            $result->status = 1;
        }
        else {
            $result->status = 0;
        }
        $result->message = $res;
        return $result->toJson();
    }


    public function getRouteDetailById($routeId = 0)
    {
        $keyWords = $routeId;

        $res = DB::table('route')->where('route_id', $keyWords)->get();

        $stopRes = DB::table('stop')->select('stop_id', 'stop_name')->get();

        $nameToId = array();
        foreach ($stopRes as $stopTmp) {
            $nameToId[$stopTmp->stop_id] = $stopTmp->stop_name;
        }

        foreach ($res as &$tmp){
            $nameList = array();
            foreach (json_decode($tmp->route_stop_list) as $idTmp){
                array_push($nameList,array('stop_id' => $idTmp, 'stop_name' => $nameToId[$idTmp]));
            }
            $tmp->route_stop_list = $nameList;
        }

        $result = new LEResult();
        if (!empty($res))
        {
            $result->status = 1;
        }
        else {
            $result->status = 0;
        }
        $result->message = $res[0];
        return $result->toJson();

    }


    public function getStopList() {
        $res = DB::table('stop')->select('stop_id','stop_name')->get();

        $result = new LEResult();
        if (!empty($res))
        {
            $result->status = 1;
        }
        else {
            $result->status = 0;
        }
        $result->message = $res;
        return $result->toJson();
    }


    public function getStopDetailById($stopId = 0)
    {
        $keyWords = $stopId;

        $res = DB::table('stop')->where('stop_id', $keyWords)->get();

        $relation = DB::table('stop_route_relation')->select('route_id','stop_id')->get();


        foreach ($res as &$tmpStop)
        {
            $routeList = array();
            foreach ($relation as $tmpRelation)
            {
                if($tmpRelation->stop_id == $tmpStop->stop_id) {
                    array_push($routeList, $tmpRelation->route_id);
                }
            }
            $tmpStop->stop_route_list = $routeList;
        }


        $result = new LEResult();
        if (!empty($res))
        {
            $result->status = 1;
        }
        else {
            $result->status = 0;
        }
        $result->message = $res[0];
        return $result->toJson();

    }


}