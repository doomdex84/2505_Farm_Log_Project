package com.example.demo.repository;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.vo.Member;

@Mapper
public interface MemberRepository {

	public int doJoin(String loginId, String loginPw, String name, String nickname, String cellphoneNum, String email,
			String postcode, String roadAddress, String jibunAddress, String detailAddress, String extraAddress);

	public Member getMemberById(int id);

	public int getLastInsertId();

	public Member getMemberByLoginId(String loginId);

	public Member getMemberByNameAndEmail(String name, String email);

	public void modify(int loginedMemberId, String loginPw, String name, String nickname, String cellphoneNum,
			String email);

	public void modifyWithoutPw(int loginedMemberId, String name, String nickname, String cellphoneNum, String email);

	public void updateAddress(Member memberParam);

	Member getMemberByKakaoId(@Param("kakaoId") String kakaoId);

	Member getMemberByGoogleId(@Param("googleId") String googleId);

	Member getMemberByNaverId(@Param("naverId") String naverId);

	int joinSocialMember(@Param("socialType") String socialType, @Param("socialId") String socialId,
			@Param("email") String email, @Param("nickname") String nickname);

	void setWithdraw(@Param("memberId") int memberId);

}