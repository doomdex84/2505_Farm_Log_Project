package com.example.demo.repository;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.Member;

@Mapper
public interface MemberRepository {

	public int doJoin(String loginId, String loginPw, String name, String nickname, String cellphoneNum, String email);

	public Member getMemberById(int id);

	public int getLastInsertId();

	public Member getMemberByLoginId(String loginId);

	public Member getMemberByNameAndEmail(String name, String email);

	public Member getMemberByEmail(String email);

	public void doLogin(String loginId, String loginPw);

	public int getMemberByLastLoginId(String loginId);

	public Member getMemberByLoginPW(String loginPw);

}