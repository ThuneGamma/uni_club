package com.feng.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.feng.entity.Activity;
import com.feng.entity.File;
import com.feng.entity.Passage;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;
import java.util.List;

/**
 * Created by rf on 2019/4/28.
 */
@Data
public class ActivityFileDto extends Activity{
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") // 前端传参格式
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") // JSON 序列化/反序列化格式
    private Date holdTime;

    private List<File> fileList;
}
