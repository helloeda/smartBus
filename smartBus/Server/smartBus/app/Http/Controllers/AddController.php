<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Http\Requests;
use \Curl\Curl;
use Psy\Util\Json;
use Illuminate\Support\Facades\DB;
class AddController extends Controller
{
    /**
     * @route add
     */
    public function add()
    {
        header("Content-type: text/html; charset=utf-8");
        //$this->addRouteStop("91路");
        $this->addStopToRoute();


    }

    /**
     * 添加公交线路和站点对应关系 多对多
     * @param
     */
    private function addStopToRoute()
    {
        $routeStopList = DB::table('route')->select('route_id', 'route_stop_list')->get();
        foreach ($routeStopList as $temp) {
            $listArr = json_decode($temp->route_stop_list);
            foreach ($listArr as $stopId) {
                $tableStopRoute = array(
                    'route_id' => $temp->route_id,
                    'stop_id' => $stopId,
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s')
                );

                if (DB::table('stop_route_relation')->where(['route_id' => $temp->route_id , 'stop_id' => $stopId])->select()->count()) {
                    echo $temp->route_id . '=>' . $stopId . "已经存在  <br>";

                } else {
                    if (DB::table('stop_route_relation')->insert($tableStopRoute))
                        echo $temp->route_id . '=>' . $stopId . "插入成功 <br>";
                    else
                        echo $temp->route_id . '=>' . $stopId . "插入失败 <br>";
                }
            }


        }
        //dump($routeStopList);
    }



    /**
     * 添加公交线路以及经过站点
     * @param $routeName 公交线路名称
     */
    private function addRouteStop($routeName)
    {
        $route = urlencode($routeName);
        $curl = new Curl();
        $curl->get('http://ditu.amap.com/service/poiBus?query_type=TQUERY&pagesize=20&pagenum=1&qii=true&cluster_state=5&need_utd=true&utd_sceneid=1000&div=PC1000&addr_poi_merge=true&is_classify=true&zoom=17&city=330100&showBackBtn=1&noreplace=1&keywords=' . $route);
        if ($curl->error) {
            echo 'Error: ' . $curl->errorCode . ': ' . $curl->errorMessage;
        } else {

            $routeData = current(current($curl->response->busData))->list;
            $stopIdList = array();
            foreach ($routeData as $temp) {
                $table_data = array(
                    'stop_name' => $temp->name,
                    'stop_longitude' => $temp->location->lng,
                    'stop_latitude' => $temp->location->lat,
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s')
                );
                $stopRes = DB::table('stop')->where('stop_name', $temp->name)->select('stop_id');

                if ($stopRes->count()) {
                    echo $temp->name . "已经存在 </br>";

                } else {
                    if ($stopId = DB::table('stop')->insert($table_data))
                        echo $temp->name . "插入成功 </br>";
                    else
                        echo $temp->name . "插入失败 </br>";
                }
                array_push($stopIdList, $stopRes->get()[0]->stop_id);
            }

            $routeList = current($curl->response->busData)[1]->list[0];


            $routeTable = array(
                'route_price' => $routeList->total_price,
                'route_name' => $routeList->key_name,
                'route_start_time' => $routeList->stime,
                'route_end_time' => $routeList->etime,
                'route_company' => $routeList->company,
                'route_price' => $routeList->total_price,
                'route_stop_list' => json_encode($stopIdList),
                'route_length' => $routeList->length,
                'created_at' => date('Y-m-d H:i:s'),
                'updated_at' => date('Y-m-d H:i:s')
            );


            if (DB::table('route')->where('route_name', $routeList->key_name)->select()->count()) {
                echo $routeList->key_name . "已经存在 </br>";

            } else {
                if (DB::table('route')->insert($routeTable))
                    echo $routeList->key_name . "插入成功 </br>";
                else
                    echo $routeList->key_name . "插入失败 </br>";
            }


        }

    }

    /**
     * 添加公交站点
     * @param $stop
     */

    private function addOneStop($stop)
    {

        $curl = new Curl();
        $url = "http://restapi.amap.com/v3/place/text?s=rsv3&children=&key=8325164e247e15eea68b59e89200988b&page=1&offset=10&city=330100&language=zh_cn&callback=jsonp_493252_&platform=JS&logversion=2.0&sdkversion=1.3&appname=http%3A%2F%2Flbs.amap.com%2Fconsole%2Fshow%2Fpicker&csid=B8429D69-9BB8-4CF0-AE7D-2BB9C068D64F&keywords";
        $curl->get($url . $stop . '(公交站)');


        if ($curl->error) {
            echo 'Error: ' . $curl->errorCode . ': ' . $curl->errorMessage;
        } else {
            $data = json_decode(substr($curl->response, 14, -1));

            if (isset($data->pois[0])) {
                $data_arr = explode(',', $data->pois[0]->location);
                $table_data = array(
                    'stop_name' => $stop,
                    'stop_longitude' => $data_arr[0],
                    'stop_latitude' => $data_arr[1],
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s')
                );

                if (DB::table('stop')->where('stop_name', $stop)->select()->count()) {
                    echo $stop . "已经存在 </br>";

                } else {
                    DB::table('stop')->insert($table_data);
                    echo $stop . "插入成功 </br>";
                }

            } else {
                echo "插入失败";
            }


        }
    }
}
