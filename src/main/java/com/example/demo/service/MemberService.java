
package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.example.demo.repository.MemberRepository;
import com.example.demo.util.Ut;
import com.example.demo.vo.Member;
import com.example.demo.vo.ResultData;

@Service
public class MemberService {

	@Value("${custom.siteMainUri}")
	private String siteMainUri;
	@Value("${custom.siteName}")
	private String siteName;

	@Autowired
	private MemberRepository memberRepository;

	@Autowired
	private MailService mailService;

	public MemberService(MemberRepository memberRepository) {
		this.memberRepository = memberRepository;
	}

	public ResultData notifyTempLoginPwByEmail(Member actor) {
		String title = "[" + siteName + "] 임시 패스워드 발송";
		String tempPassword = Ut.getTempPassword(6);
		String body = "<h1>임시 패스워드 : " + tempPassword + "</h1>";
		body += "<a href=\"" + siteMainUri + "/usr/member/login\" target=\"_blank\">로그인 하러가기</a>";

		ResultData sendResultData = mailService.send(actor.getEmail(), title, body);

		if (sendResultData.isFail()) {
			return sendResultData;
		}

		setTempPassword(actor, tempPassword);

		return ResultData.from("S-1", "계정의 이메일주소로 임시 패스워드가 발송되었습니다.");
	}

	private void setTempPassword(Member actor, String tempPassword) {
		memberRepository.modify(actor.getId(), Ut.sha256(tempPassword), null, null, null, null);
	}

	public ResultData<Integer> join(String loginId, String loginPw, String name, String nickname, String cellphoneNum,
			String email, String postcode, String roadAddress, String jibunAddress, String detailAddress,
			String extraAddress) {

		Member existsMember = getMemberByLoginId(loginId);

		if (existsMember != null) {
			return ResultData.from("F-7", Ut.f("이미 사용중인 아이디(%s)입니다", loginId));
		}

		existsMember = getMemberByNameAndEmail(name, email);

		if (existsMember != null) {
			return ResultData.from("F-8", Ut.f("이미 사용중인 이름(%s)과 이메일(%s)입니다", name, email));
		}

		loginPw = Ut.sha256(loginPw);

// ✅ 주소까지 포함해서 저장
		memberRepository.doJoin(loginId, loginPw, name, nickname, cellphoneNum, email, postcode, roadAddress,
				jibunAddress, detailAddress, extraAddress);

		int id = memberRepository.getLastInsertId();

		return ResultData.from("S-1", "회원가입 성공", "가입 성공 id", id);
	}

	public Member getMemberByNameAndEmail(String name, String email) {
		return memberRepository.getMemberByNameAndEmail(name, email);

	}

	public Member getMemberByLoginId(String loginId) {
		return memberRepository.getMemberByLoginId(loginId);
	}

	public Member getMemberById(int id) {
		return memberRepository.getMemberById(id);
	}

	public ResultData modify(int loginedMemberId, String loginPw, String name, String nickname, String cellphoneNum,
			String email) {

		loginPw = Ut.sha256(loginPw);

		memberRepository.modify(loginedMemberId, loginPw, name, nickname, cellphoneNum, email);

		return ResultData.from("S-1", "회원정보 수정 완료");
	}

	public ResultData modifyWithoutPw(int loginedMemberId, String name, String nickname, String cellphoneNum,
			String email) {
		memberRepository.modifyWithoutPw(loginedMemberId, name, nickname, cellphoneNum, email);

		return ResultData.from("S-1", "회원정보 수정 완료");
	}

	public void registerAddress(Member memberParam) {
		memberRepository.updateAddress(memberParam);
	}

	// ✅ 카카오 ID로 회원 조회
	public Member getMemberByKakaoId(String kakaoId) {
		return memberRepository.getMemberByKakaoId(kakaoId);
	}

	// ✅ 구글 ID로 회원 조회
	public Member getMemberByGoogleId(String googleId) {
		return memberRepository.getMemberByGoogleId(googleId);
	}

	// ✅ 네이버 ID로 회원 조회
	public Member getMemberByNaverId(String naverId) {
		return memberRepository.getMemberByNaverId(naverId);
	}

	// ✅ 소셜 회원 최초 로그인 시 자동 가입 (선택사항)
	public ResultData joinSocialMember(String socialType, String socialId, String email, String nickname) {
		int affectedRow = memberRepository.joinSocialMember(socialType, socialId, email, nickname);
		if (affectedRow == 1) {
			return ResultData.from("S-1", "회원가입 성공");
		}
		return ResultData.from("F-1", "회원가입 실패");
	}

	public void withdrawMember(int memberId) {
		memberRepository.setWithdraw(memberId);
	}

	public boolean checkPassword(int memberId, String rawPassword) {
		Member member = memberRepository.getMemberById(memberId);
		if (member == null)
			return false;

		String encryptedInput = Ut.sha256(rawPassword);

		return member.getLoginPw().equals(encryptedInput);
	}

}