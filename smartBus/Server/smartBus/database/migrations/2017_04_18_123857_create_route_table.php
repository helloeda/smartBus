<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateRouteTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('route', function (Blueprint $table) {
            $table->increments('route_id');
            $table->string('route_name'); //线路名称
            $table->string('route_stop_list'); //线路经过站点列表
            $table->string('route_start_time'); //开始时间
            $table->string('route_end_time'); //结束时间
            $table->string('route_price'); //票价
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        //
    }
}
