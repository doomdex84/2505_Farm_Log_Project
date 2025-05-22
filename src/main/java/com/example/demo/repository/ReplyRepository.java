package com.example.demo.repository;

import java.util.List;

import com.example.demo.vo.Reply;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ReplyRepository {
	
	
    List<Reply> getForPrintReplies(String relTypeCode, int relId);
}

