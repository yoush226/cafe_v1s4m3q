<%@ page contentType="text/html; charset=UTF-8" %>
 
<!DOCTYPE html> 
<html lang="ko"> 
<head> 
<meta charset="UTF-8"> 
<title></title> 
 
<link href="../css/style.css" rel="Stylesheet" type="text/css">

<script type="text/JavaScript"
          src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script type="text/javascript" src="../js/jquery.cookie.js"></script>

<!-- 합쳐지고 최소화된 최신 CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<!-- 부가적인 테마 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
<!-- 합쳐지고 최소화된 최신 자바스크립트 -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
  
<script type="text/javascript">
  
  $(function() {
    $.cookie('checkId', 'FALSE'); // 쿠키 생성
    $('#popup').hide();
  });
 
  function checkId(){
    var params = 'id=' + $('#id').val(); // #: id
    $.get('./checkId.do', params, checkId_res, 'json');
  }
  
  function checkId_res(data) {
    // alert(data.cnt);
    // var id_panel = document.getElementById('id_panel');
    var id_panel = $('#id_panel');
    if (data.cnt == 0) {
      // id_panel.innerHTML = '아이디가 사용 가능합니다.';
      id_panel.html('아이디가 사용 가능합니다.');
      // id_panel.style.color = '#00AA00';
      id_panel.css('color', '#00AA00');
      $.cookie('checkId', 'PASS'); // 쿠키 생성
    } else {
      id_panel.html('아이디가 중복됩니다.');
      id_panel.css('color', '#FF0000');
      // document.getElementById('id').value = '';
      // $('#id').val(''); // 값 제거
      // document.getElementById('id').focus();
      $('#id').focus();
      $.cookie('checkId', 'FALSE'); // 쿠키 생성      
    }
  }
  
  function send() {
    var id_panel = $('#id_panel');
    var check = $.cookie('checkId'); // 쿠키값
    // alert('check: ' + check);
    if (check != 'PASS') {
      id_panel.html('중복 ID 검사를 해주세요.');
      id_panel.css('color', '#FF0000');
      id_panel.focus();
      return false;
    }
    
    if ($('#passwd').val() != $('#passwd2').val()) {
      $('#popup').show();
      return false;
    }
    
    return true; 
    
  }
</script>
 
</head> 
 
 
<body>
<DIV class='container'>
<jsp:include page="/menu/top.jsp" flush='false' />
<DIV class='content' style='width: 80%;'>
 
  <!-- 레이어 선언 -->
  <DIV id='popup' class='popup1' style='height: 200px; display: none;'>
    알림 <br><br>
    패스워드가 일치하지 않습니다.<br><br><br>
    <SPAN class='box1'><A href="javascript: $('#popup').hide(); $('#passwd').focus();">CLOSE</A></SPAN>
  </DIV>
 
<DIV class='title'>회원가입</DIV>
 
<FORM name='frm' method='POST' action='./create.do' 
            onsubmit="return send();">
  <fieldset>
    <ul>
      <li>
        <label class='label' for='id'>아이디</label>
        <input type='text' name='id' id='id' value='user1' required="required">
        <button type='button' onclick="checkId()">중복확인</button>
        <SPAN id='id_panel'></SPAN> <!-- ID 중복 관련 메시지 -->        
      </li>
      <li>
        <label class='label' for='passwd'>패스워드</label>
        <input type='password' name='passwd' id='passwd' value='1234' required="required">
          &nbsp;&nbsp;
        <label class='label' for='passwd2'>패스워드 확인</label>
        <input type='password' name='passwd2' id='passwd2' value='1234' required="required">
 
      </li>
      <li>
        <label class='label' for='mname'>성명</label>
        <input type='text' name='mname' id='mname' value='왕눈이' required="required">
      </li>
      <li>
        <label class='label' for='tel'>전화번호</label>
        <input type="tel" name='tel' id='tel' value='010-0000-0000'> 예) 010-0000-0000
      </li>
      <li>
        <label class='label' for='zipcode'>우편번호</label>
        <input type='text' name='zipcode' id='zipcode' value='' placeholder="우편번호">
        <input type="button" onclick="DaumPostcode()" value="우편번호 찾기"><br>        
      </li>
      <li>
        <label class='label' for='zipcode'>주소</label>
        <input type='text' name='address1' id='address1' value='' size='55' placeholder="주소">  
        <input type='text' name='address2' id='address2' value='' size='20' placeholder="상세 주소">      
      </li>
      <li>
        <label class='label'></label>  
 
<!-- ----- DAUM 우편번호 API 시작 ----- -->
 
<div id="wrap" style="display:none;border:1px solid;width:500px;height:300px;margin:5px 110px;position:relative">
  <img src="//i1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1" onclick="foldDaumPostcode()" alt="접기 버튼">
</div>
 
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
    // 우편번호 찾기 찾기 화면을 넣을 element
    var element_wrap = document.getElementById('wrap');
 
    function foldDaumPostcode() {
        // iframe을 넣은 element를 안보이게 한다.
        element_wrap.style.display = 'none';
    }
 
    function DaumPostcode() {
        // 현재 scroll 위치를 저장해놓는다.
        var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
        new daum.Postcode({
            oncomplete: function(data) {
                // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
 
                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = data.address; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수
 
                // 기본 주소가 도로명 타입일때 조합한다.
                if(data.addressType === 'R'){
                    //법정동명이 있을 경우 추가한다.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }
 
                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('zipcode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('address1').value = fullAddr;
 
                // iframe을 넣은 element를 안보이게 한다.
                // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
                element_wrap.style.display = 'none';
 
                // 우편번호 찾기 화면이 보이기 이전으로 scroll 위치를 되돌린다.
                document.body.scrollTop = currentScroll;
                
                $('#address2').focus();
            },
            // 우편번호 찾기 화면 크기가 조정되었을때 실행할 코드를 작성하는 부분. iframe을 넣은 element의 높이값을 조정한다.
            onresize : function(size) {
                element_wrap.style.height = size.height+'px';
            },
            width : '100%',
            height : '100%'
        }).embed(element_wrap);
 
        // iframe을 넣은 element를 보이게 한다.
        element_wrap.style.display = 'block';
    }
</script>
<!-- ----- DAUM 우편번호 API 종료----- -->
        
      </li>
      <li class='right'>
        <button type="submit">가입</button>
        <button type="button" onclick="location.href='../index.jsp'">취소</button>
      </li>         
    </ul>
  </fieldset>
</FORM>
 
</DIV> <!-- content END -->
<jsp:include page="/menu/bottom.jsp" flush='false' />
</DIV> <!-- container END -->
</body>
 
</html> 