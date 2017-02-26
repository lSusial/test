<!DOCTYPE html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<style type="text/css">
body {width: 800px;}
.sr-detail {border-collapse: collapse;}
.sr-detail td {border: solid #dddddd 1.0pt; padding: 5px;}
hr {margin-top: 10px;margin-bottom: 10px; border: 0; border-top: 1px solid #eee;}
.noti p {line-height: 80%;}
</style>
</head>
<body width="800" style="width:800;">
<!--[if mso]>
 <center>
 <table><tr><td width="700">
<![endif]-->
 <div style="max-width:700px; margin:0 auto;">
 
<div class="noti" >
<p style="line-height: 80%;">안녕하세요</p>
<p style="line-height: 80%;">아래의 NEW SR 업무시스템에 결재 요청이 있습니다. </p>
<p style="line-height: 80%;">확인 부탁 드립니다.</p>
</div>

<h3>${title}</h3> 
<table class="table sr-detail" width="100%" style="border-collapse: collapse;" >
  <tr>
    <td style="border: solid #dddddd 1.0pt; padding: 5px;" width=" 120" class="td-head">요청자</td> 
    <td style="border: solid #dddddd 1.0pt; padding: 5px;" width=" 180"> ${reqEmpNm} / ${reqEmpDeptNm} </td>
    <td style="border: solid #dddddd 1.0pt; padding: 5px;" width=" 120" class="td-head">요청일 </td> 
    <td style="border: solid #dddddd 1.0pt; padding: 5px;" width=" 180"> ${crtDttm} </td>
  </tr>
  <tr>
    <td style="border: solid #dddddd 1.0pt; padding: 5px;" class="td-head">SR 번호</td> 
    <td style="border: solid #dddddd 1.0pt; padding: 5px;"> ${srNo} </td>
    <td style="border: solid #dddddd 1.0pt; padding: 5px;"class="td-head">희망 완료일</td> 
    <td style="border: solid #dddddd 1.0pt; padding: 5px;">  ${tgtDttm} </td>
  </tr>
  <tr>
    <td style="border: solid #dddddd 1.0pt; padding: 5px;" class="td-head">요청 구분</td> 
    <td style="border: solid #dddddd 1.0pt; padding: 5px;">  ${srTypeNm}</td>
    <td style="border: solid #dddddd 1.0pt; padding: 5px;" class="td-head">상태</td> 
    <td style="border: solid #dddddd 1.0pt; padding: 5px;">  ${statusNm} </td>
  </tr>
  <tr>
    <td style="border: solid #dddddd 1.0pt; padding: 5px;" class="td-head" >시스템</td> 
    <td style="border: solid #dddddd 1.0pt; padding: 5px;" colspan="3"> ${sysNm} </td>
  </tr>
</table>
<hr style="margin-top: 10px;margin-bottom: 10px; border: 0; border-top: 1px solid #eee;">
${desc}



<br>
<br>
<br>
<hr style="margin-top: 10px;margin-bottom: 10px; border: 0; border-top: 1px solid #eee;">
<p>Send by Homeplus New SR System</p>
<p>http://nsr.homeplusnet.co.kr</p>

 /div>
<!--[if mso]>
 </td></tr></table>
 </center>
<![endif]--> 
<div style="margin: auto; width: 80%;">
</body>
</html>
