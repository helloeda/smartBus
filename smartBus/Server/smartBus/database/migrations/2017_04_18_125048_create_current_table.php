<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateCurrentTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('current', function (Blueprint $table) {
            $table->increments('current_id');
            $table->string('current_bus'); //当前运营车辆id
            $table->string('current_passenger'); //当前乘客数
            $table->string('current_longitude'); //当前经度
            $table->string('current_latitude'); //当前纬度
            $table->boolean('current_direction'); //当前方向:1正向；0逆向
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
