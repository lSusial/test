<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>	<!-- 스마트에디터 -->

<script>  
    
$(document).ready(function() {
    Regist.initEditor();
    $.fn.datepicker.defaults.format = "yyyy-mm-dd";
    $(function() {
        var today = new Date();
		$("#tgtDttm .input-group.date").datepicker({
			changeMonth: true, 
			changeYear: true,
			showMonthAfterYear: true,
			startDate: '0d',
			language: 'kr',
		    autoclose: true,
		    todayHighlight: true
		});
	});
    
    var $content = $('#registView');
    
    $content.on('click', '#addAprvBtn', Regist.showEmpSearchModal);
    //$content.on('click', '#searchEmpBtn', Regist.searchEmployee);
    $content.on('click', '#approvalLineTablebody .apprDelBtn', Regist.deleteAprrover);
    $content.on('change', '#sysCateSelector', Regist.selectSystemList);
    $content.on('change', '#systemSelector', Regist.selectITApprovalLine);
    $content.on('change', '#srTypeSelector', Regist.toggleApprovalLineArea);
    $content.on('click', '#submitBtn', Regist.submit);

    $content.on('change', 'input[type=radio][name=confDataYn]', Regist.alertConfData);
   
    $('#modalView').on('click', '#modalEmpTable.apporval tr', Regist.appendAprrover);
    
    
});



</script>

<div id="registView">
  <div class="container">
    <ol class="breadcrumb">
      <li>SR 등록 요청서</li>
    </ol>
</div>


<div class="container">
<form class="form-horizontal" name="registerForm" enctype="multipart/form-data"> 
   <%-- 신청자 정보 Start--%>  
   <input type="hidden" name="ifType" value="RTC">
  <input type="hidden" name="sysTpCd" value="SW">
  <input type="hidden" name="etc1" value="HTML">
   
  <div class="panel panel-default reqEmpPanel">
    <div class="panel-heading hp-panel-narrow">
        요청자 (${sessionScope.userInfo.userNm})
    </div> 
    
    <div class="panel-body form-horizontal hp-panel-narrow">
      <div class="form-group no-bottom-margin">
        <label for="reqDeptNm" class="col-xs-1 control-label text-left" >부서</label>
        <div class="col-xs-3">
          <input type="text" class="form-control " id="reqDeptNm"  value="${sessionScope.userInfo.deptNm}" readonly>
        </div>
        <%-- 
        <label for="reqEmpTel" class="col-xs-1 control-label text-left" >연락처</label>
        <div class="col-xs-3">
          <input type="text" class="form-control " id="reqEmpTel" name="reqEmpTel" placeholder="">
        </div>
        <label for="reqEmpEmail" class="col-xs-1 control-label text-left" >이메일</label>
        <div class="col-xs-3">
          <input type="text" class="form-control " id="reqEmpEmail" name="reqEmpEmail" value="${sessionScope.userInfo.email}">
        </div>
         --%>
      </div>
    </div>
  </div>
  <%-- 신청자 정보 End--%>
  
  <%-- SR Type & System Start--%>
  <div class="panel panel-default typeNSysPanel">
    <div class="panel-heading hp-panel-narrow">
        요청 구분
    </div> 
    
    <div class="panel-body hp-panel-narrow">
      <div class="form-group ">
          <!-- <div class="col-xs-1 control-label text-left" > </div> -->
          <div class="col-xs-4">
            <select class="form-control form-control-sm" id="srTypeSelector" name="srTypeId">
              <option value="">선택</option>
            <c:forEach items="${typeList}" var="type" >
              <option value="${type.srTypeId}" >${type.srTypeNm} </option> 
            </c:forEach>
            </select>
          </div>
           <div class="col-xs-4">
             <select class="form-control form-control-sm" id="sysCateSelector" name="sysCateId">
               <option>선택</option>
               <c:forEach items="${sysCateList}" var="sysCate" >
               <option value="${sysCate.cdId}" data-type="<c:out value="${sysCate.attr1}" default="ALL" />${sysCate.attr1}">${sysCate.cdNm} </option> 
               </c:forEach>
             </select>
          </div>
           <div class="col-xs-4">
            <select class="form-control form-control-sm" id="systemSelector"name="sysId">
              <option>선택</option>
            </select>
          </div>
        </div>
    </div>
  </div>
  <%-- SR Type & System End--%>
  
  <%-- 결재 라인 정보 Start--%>
  <div id="approvalPanel" style="display:none;">
  <div class="row">
  <div class="col-xs-6">
  <div class="panel panel-default" >
    <div class="panel-body hp-panel-narrow approval-panel">
      
      <p>승인자</p>
      <table class="table table-hover approvalLineTable">
      <thead>
        <tr>
          <th>#</th>
          <th>부서</th>
          <th>직급</th>
          <th>이름</th>
          <th class="text-right"> <input class="btn btn-primary btn-sm" id="addAprvBtn" type="button" value="추가"></th>
        </tr>
      </thead>
      <tbody id ="approvalLineTablebody">
      <c:forEach items="${approvalLine}" var="approval" varStatus="status">
        <tr data-emp-id="${approval.aprvEmpId}" data-dept-id ="${approval.aprvDeptId}">
          <td>${status.count}차 결재</td>
          <td>${approval.aprvDeptNm}</td>
          <td>${approval.aprvEmpJobTitle}</td>
          <td>${approval.aprvEmpNm}</td>
          <td class="text-right"> <input class="btn btn-danger btn-sm apprDelBtn" type="button" value="삭제"> </td>
        </tr>
      </c:forEach>
      </tbody>
      </table>

    </div>
  </div>
  </div>
  <div class="col-xs-6">
  <div class="panel panel-default" >
    <div class="panel-body hp-panel-narrow approval-panel">
      
      <p>IT 승인자</p>
      <table class="table table-hover">
      <thead>
        <tr>
          <th>#</th>
          <th>부서</th>
          <th>직급</th>
          <th>이름</th>
          <th class="text-right"><input class="btn btn-primary btn-sm disabled" style="border-color:#fff; background-color:#fff;" type="button" value="추가"></th>
        </tr>
      </thead>
      <tbody id ="approvalITLineTablebody">
      </tbody>
      </table>
    
    </div>
  </div>
  </div>
  </div>
  </div>
  <%-- 결재 정보 end --%>
  
  <%-- SR 작성 Start (내용, 날짜, 파일) --%>
  <div class="panel panel-default ">
    <div class="panel-body hp-panel-narrow">
      
      
      <div class="form-group">
        <label class="control-label col-xs-2 text-left" for="exampleTextarea">제목</label>
        <div class="col-xs-10">
        <input text class="form-control " name="title" maxlength="150"/>
        </div>
      </div>
      
      <div class="form-group">
        <label class="control-label col-xs-2 text-left" for="exampleTextarea">희망 완료일</label>
        <div class="col-xs-3" id="tgtDttm">
        <div class="input-group date" >
          <input type="text" name="tgtDttm" class="form-control" >
          <div class="input-group-addon">
            <span class="glyphicon glyphicon-th"></span>
          </div>
        </div>
        </div>
        <div id = "addInfoAboutDataSR" style="display:none;">
        <div class="col-xs-2-5">
            <select class="form-control form-control-sm" name = "dataType">
               <option value="">선택</option>
               <c:forEach items="${dataTypeList}" var="dataType" >
               <option value="${dataType.cdId}" >${dataType.cdNm} </option> 
               </c:forEach>
            </select>
        </div>
        
        <label class="control-label col-xs-2">개인 정보 포함 여부</label>
        <label class="radio-inline">
          <input type="radio" name="confDataYn" id="inlineRadio1" value="Y"> 포함
        </label>
        <label class="radio-inline">
          <input type="radio" name="confDataYn" id="inlineRadio2" value="N"> 미 포함
        </label>
        
        </div>
        
      </div>
      <div class="form-group">
        <textarea class="form-control" name="desc" id="reqDesc" rows="3"></textarea>
      </div>
      <div class="form-group">
        <label class="control-label col-xs-2 " for="exampleTextarea">첨부 파일</label>
        <input type="file" name="files" class="form-control-file" id="exampleInputFile" aria-describedby="fileHelp">
        <input type="file" name="files" class="form-control-file" id="exampleInputFile2" aria-describedby="fileHelp">
      </div>
    </div>
  
  </div>
  
  <div class="text-right">
      <input class="btn btn-primary submit" id="submitBtn" type="button" value="등록"> 
  </div>
  
  <input type="hidden" name="approvalListJson">
  <input type="hidden" name="approvalITListJson">
  
  <%-- SR 작성 Start End --%>
</form>
</div> <!-- end view -->

<%-- Template Start--%>
<div style="display:none;">
<select id="tempSelector">
   <option>선택</option>
   <c:forEach items="${sysCateList}" var="sysCate" >
   <option value="${sysCate.cdId}" data-type="<c:out value="${sysCate.attr1}" default="ALL" />${sysCate.attr1}">${sysCate.cdNm} </option> 
   </c:forEach>
 </select>
</div>

<%-- Template End--%>


