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


    public function getCurrent($routeId = 0)
    {

        $result = new LEResult();
        $res = DB::table('current')
            ->join('bus', 'current.bus_id', '=', 'bus.bus_id')
            ->join('route', 'bus.bus_route', '=', 'route.route_id')
            ->where('route_id', $routeId)
            ->select('current.updated_at', 'current.bus_id', 'current.current_passenger', 'bus.bus_capacity',
                'current.current_longitude', 'current.current_latitude', 'route.route_stop_list','bus.bus_no')
            ->get();

        //没查记录返回
        if (!isset($res[0])) {
            $result->status = 0;
            return $result->toJson();
        }

        $currentList = array();

        foreach ($res as $tmpRes) {
            $longitude = sprintf("%.6f", $tmpRes->current_longitude);

            $latitude = sprintf("%.6f", $tmpRes->current_latitude);

            $locations = $longitude . ',' . $latitude;


            $curl = new Curl();

            $postData = array(
                'key' => '180c11748daa46093e622a9022e489fa',
                'locations' => $locations,
                'coordsys' => 'gps',
            );

            $curl->get('http://restapi.amap.com/v3/assistant/coordinate/convert', $postData);
            if ($curl->error) {
                continue;
            } else {
                if ($curl->response->status == 0) {
                    continue;
                } else {
                    $hxLocations = explode(',', $curl->response->locations);
                    $arrStopList = json_decode($tmpRes->route_stop_list);

                    $currentLongitude = $hxLocations[0];
                    $currentLatitude = $hxLocations[1];

                    $deltaArr = array();

                    foreach ($arrStopList as $tmp) {
                        $stop = DB::table('stop')->where('stop_id', $tmp)->select()->get();
                        $stopLongitude = $stop[0]->stop_longitude;
                        $stopLatitude = $stop[0]->stop_latitude;
                        $delta = sqrt(pow(($currentLongitude - $stopLongitude), 2) + pow(($currentLatitude - $stopLatitude), 2));
                        $deltaArr['' . $delta . ''] = $tmp;
                    }

                    ksort($deltaArr); //根据索引排序

                    $currentRes = array(
                        'bus_id' => $tmpRes->bus_id,
                        'current_stop' => current($deltaArr),
                        'current_passenger' => $tmpRes->bus_capacity-$tmpRes->current_passenger,
                        'bus_capacity' => $tmpRes->bus_capacity,
                        'bus_no' => $tmpRes->bus_no
                    );

                    if((time() - strtotime($tmpRes->updated_at)) <= 100)
                        array_push($currentList, $currentRes);
                }
            }
        }
        if(count($currentRes) == 0){
            $result->status = 0;
            return $result->toJson();
        }
        else{
            $result->status = 1;
            $result->message = $currentList;
            return $result->toJson();
        }

    }

    //硬件API
    public function setGps(Request $request) {
        $jd = $request->input("jd");
        $wd = $request->input("wd");

        $jd = substr($jd,0,-1);
        $wd = substr($wd,0,-1);
        $fin_jd = floor($jd / 100) + ($jd % 100) / 60 + ($jd - floor($jd)) / 60;
        $fin_wd = floor($wd / 100) + ($wd % 100) / 60 + ($wd - floor($wd)) / 60;
        $fin_sensor =  $request->input("sensor");

        $data= array(
            'current_longitude' => $fin_jd,
            'current_latitude' => $fin_wd,
            'current_passenger' =>   $fin_sensor ,
            'updated_at' => date('Y-m-d H:i:s'),
        );
        $res = DB::table('current')->where("bus_id",1)->update($data);
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






}
