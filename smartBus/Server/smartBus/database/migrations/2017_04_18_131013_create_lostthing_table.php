<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateLostthingTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        //
        Schema::create('lostthing', function (Blueprint $table) {
            $table->increments('lostthing_id');
            $table->string('lostthing_title'); //失物招领标题
            $table->text('lostthing_content'); //失物招领内容
            $table->string('lostthing_author'); //发布者
            $table->boolean('lostthing_type'); //1:失物招领；0:招领启示
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
