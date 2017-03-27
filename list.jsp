<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp" %>
<script src="${JS_URL}/jquery.twbsPagination.min.js"></script>
<script>

var List =  {
    LIST_URL : '/sr/list.do',
    DETAIL_URL : '/sr/detail.do',
    showDetail : function (e) {
        var srId =  $(this).attr('data-sr-id');
        location.href = List.DETAIL_URL + '?srNo=' + srId;
        
    },
    
    search : function () {
        var frm = document.forms['listForm'];
        frm.action = List.LIST_URL;
        frm.submit(); 
    },
    
    showEmpSearchModalForSearch : function (e) {
        Modal.showEmpSearchModal('searchCondition');
    },
    
    setReqEmpId : function(data){
        
        var $addEl = $(this).clone();
        $('#searchEmpName').val($addEl.children('.empName').text());
        $('#reqEmpId').val($addEl.attr('data-emp-id'));
        
        $('#empSearcModal').modal('hide');
    
    },
    
};
    
$(document).ready(function() {
    $.fn.datepicker.defaults.format = "yyyy-mm-dd";
    $('#dateRange .input-daterange').datepicker({
        startDate: "-90d",
        endDate: "0d",
        autoclose: true
    });
    
	var $content = $('#listView');
	$content.on('click', '#srList tr', List.showDetail);
	$content.on('click', '#searchBtn', List.search);
	$content.on('click', '#searchEmpName', List.showEmpSearchModalForSearch);
	
	$('#modalView').on('click', '#modalEmpTable.searchCondition tr', List.setReqEmpId);
	
	var firstPageClick = true;
	
	$('#pagination-demo').twbsPagination({
        totalPages:   <c:out value="${srList[0].totalPage}" default="1" />,
        visiblePages: 7,
        startPage : <c:out value="${condition.currentPage}" default="1" />,
        onPageClick: function (event, page) {
            $('#currentPage').val(page);
            if(firstPageClick) {
                firstPageClick = false;
                return;
            }
            List.search();
        }
    });
    
    $('#conditionFrm .condition').each(function() {
        var elem = $(this);
    
        // Save current value of element
        elem.data('oldVal', elem.val());
    
        // Look for changes in the value
        elem.bind("propertychange change click keyup input paste", function(event){
           // If value has changed...
           if (elem.data('oldVal') != elem.val()) {
            // Updated stored value
            elem.data('oldVal', elem.val());
            $('#currentPage').val(1);
          }
        });
      });
});


</script>
<div id="listView">
<div class="container">
  <ol class="breadcrumb">
    <li>요청 목록</li>
  </ol>
<div class="panel panel-default">
  <!-- <div class="panel-heading ">
      Default Panel
  </div> -->
  <div class="panel-body">
    <form id="conditionFrm"class="form-horizontal" name="listForm" method="post">
    <input type="hidden" id="currentPage" name="currentPage" value="<c:out value="${condition.currentPage}" default="1" />" >
    <input type="hidden" id="totalPage" name="totalPage" value="<c:out value="${srList[0].totalPage}" default="1" />" >
      <div class="form-group ">
        <label for="searchSrNo" class="col-xs-1 control-label text-left" >요청 번호</label>
        <div class="col-xs-2">
          <input type="text" class="form-control condition" id="searchSrNo" name="srNo" placeholder="" value ="${condition.srNo}" >
        </div>
        <label for="searchEmpName" class="col-xs-1 control-label text-left" >요청자</label>
        <div class="col-xs-2">
          <input type="text" class="form-control condition" id="searchEmpName" name="reqEmpNm" readonly style="background-color: #fff;">
          <input type="hidden" name="reqEmpId" id="reqEmpId" value="">
        </div>
        <label for="searchTitle" class="col-sm-1 control-label text-left" >제목</label>
        <div class="col-xs-5">
          <input type="text" class="form-control condition" name="title" id="searchTitle" placeholder="" value="${condition.title}" >
        </div>
      </div>
      <div class="form-group ">
        <label for="exampleInputEmail1" class="col-xs-1 control-label text-left" >신청 기간</label>
        <div id="dateRange" class="col-xs-4">
          <div class="input-daterange ">
            <input type="text" style="width:120px;float:left; border-radius :3px;" class="form-control condition" name="strDt" value ="${condition.strDt}"/>
            <div class="dateTilde" style="float:left; margin: 1px 10px;">&nbsp;~&nbsp;</div>
            <input type="text" style="width:120px;float:left; border-radius :3px;"  class="form-control condition" name="endDt" value ="${condition.endDt}"/>
          </div>
        </div>
        <label for="exampleInputPassword1" class="col-xs-1 control-label text-left" >상태</label>
        <div class="col-xs-2">
          <select class="form-control form-control-sm condition" name="status">
          <option value="" >선택</option> 
          <c:forEach items="${statusList}" var="status" >
            <option value="${status.cdId}" <c:if test="${status.cdId eq condition.status}" >selected</c:if> >${status.cdNm} </option> 
          </c:forEach>
          </select>
        </div>
        <label for="exampleInputPassword1" class="col-xs-1 control-label text-left" >요청 구분</label>
        <div class="col-xs-3">
          <select class="form-control form-control-sm condition" name="srTypeId">
            <option value="">선택</option>
            <c:forEach items="${typeList}" var="type" >
            <option value="${type.srTypeId}" <c:if test="${type.srTypeId eq condition.srTypeId}" >selected</c:if> >${type.srTypeNm} </option> 
          </c:forEach>
          </select>
        </div>
        
      </div>
       <div class="form-group ">
       
       </div>
    </form>
  </div>
  <div class="panel-footer">
    <div class="text-right">
      <input class="btn btn-primary" id="searchBtn" type="button" value="검색">
    </div>
  </div>
</div>
</div>
<div class="container">

<table class="table table-hover sr-list-table">
  <thead>
    <tr>
      <th width="110px">요청번호</th>
      <th width="100px">요청 구분</th>
      <th width="100px">시스템</th>
      <th>제목</th>
      <th width="100px" style="text-align: center;" >상태</th>
      <th width="90px">요청자</th>
      <th width="90px">처리자</th>
      <th width="90px" style="text-align: center;">접수일자</th>
    </tr>
  </thead>
  <tbody class="srList" id="srList">
    <c:forEach items="${srList}" var="sr" >
    <tr data-sr-id="${sr.srNo}" >
      <td>${sr.srNo}  </td>
      <%-- <c:choose>
       <c:when test="${sr.ifType eq 'RTC'}">
       <td>업무 시스템</td>
       </c:when>
       <c:when test="${sr.ifType eq 'TKT'}">
       <td>장비/하드웨어</td>
       </c:when>
       <c:otherwise>
       <td></td>
       </c:otherwise>
      </c:choose> --%>
      <td>${sr.srTypeNm}  </td>
      <td>${sr.sysNm}  </td>
      <td>${sr.title}  </td>
      <td style="text-align: center;">${sr.statusNm}  </td>
      <td>${sr.reqEmpNm}  </td>
      <td>${sr.chrgEmpNm}  </td>
      <td style="text-align: center;" >${sr.crtDt}  </td>
    </tr>
    </c:forEach>
    
  </tbody>
</table>
   <div class="text-center">
      <ul id="pagination-demo" class="pagination-sm"></ul>
    </div>

</div>
</div>

