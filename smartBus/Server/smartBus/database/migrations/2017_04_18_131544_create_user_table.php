<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateUserTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        //
        Schema::create('user', function (Blueprint $table) {
            $table->increments('user_id');
            $table->string('user_username'); //用户名
            $table->string('user_password'); //密码
            $table->string('user_mail'); //邮箱
            $table->string('user_icon'); //头像
            $table->string('user_phone'); //电话
            $table->string('user_token'); //token
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
