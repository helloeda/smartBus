<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateSuggestTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        //
        Schema::create('suggest', function (Blueprint $table) {
            $table->increments('suggest_id');
            $table->string('suggest_title'); //建议标题
            $table->text('suggest_content'); //建议内容
            $table->string('suggest_author'); //发布者
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
