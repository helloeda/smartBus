<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateStopTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('stop', function (Blueprint $table) {
            $table->increments('stop_id');
            $table->string('stop_name'); //站点名称
            $table->string('stop_longitude'); //站点经度
            $table->string('stop_latitude'); //站点纬度
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
