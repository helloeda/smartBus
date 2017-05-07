<?php

/**
 * Created by PhpStorm.
 * User: eda
 * Date: 2017/4/18
 * Time: 下午11:32
 */
namespace App\Models;

class LEResult
{
    public $status;
    public $message;
    public function toJson()
    {
        return json_encode($this, JSON_UNESCAPED_UNICODE);
    }
}