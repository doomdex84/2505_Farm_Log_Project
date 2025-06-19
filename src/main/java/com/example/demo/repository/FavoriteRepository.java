package com.example.demo.repository;

import com.example.demo.vo.Farmlog;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface FavoriteRepository {

	void insertFavorite(@Param("memberId") long memberId, @Param("farmlogId") long farmlogId);

	void deleteFavorite(@Param("memberId") long memberId, @Param("farmlogId") long farmlogId);

	int selectIsFavorite(@Param("memberId") long memberId, @Param("farmlogId") long farmlogId);

	List<Farmlog> selectFavoriteFarmlogs(@Param("memberId") long memberId);

	boolean existsFavorite(@Param("memberId") long memberId, @Param("farmlogId") long farmlogId);

}
