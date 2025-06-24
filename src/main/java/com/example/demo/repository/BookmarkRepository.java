package com.example.demo.repository;

import com.example.demo.vo.Farmlog;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BookmarkRepository {

	void insertBookmark(@Param("memberId") long memberId, @Param("farmlogId") long farmlogId);

	void deleteBookmark(@Param("memberId") long memberId, @Param("farmlogId") long farmlogId);

	int selectIsBookmark(@Param("memberId") long memberId, @Param("farmlogId") long farmlogId);

	List<Farmlog> selectBookmarkFarmlogs(@Param("memberId") long memberId);
}
