//<![CDATA[


var Regist =  {
    oEditors : [],
    SEARCH_URL : '/json/searchEmp.json',
    APPROVAL_RULE_URL : '/json/searchITApprovalRule.json',
    SELECT_SYSTEM_URL : '/sr/getSystemList.json',
    SELECT_MODULE_URL : '/sr/getModuleList.json',
    REGIST_URL : '/sr/registSR.do',
    
    
    indexingTable : function($table, tdIndex){
        $table.find('tr').each(function (i) {
            $('td:eq('+ tdIndex +')', this).html(i + 1 +'차 결재');
         });
    },
    
    
    appendAprrover : function(data){
        var $addEl = $(this).clone();
        var $approverEl = $('#approvalLineTablebody');
        
        var appendYn = true;
        $approverEl.find('tr').each(function (i,el) {
            var approverId=  $(el).attr('data-emp-id');
            if($addEl.attr('data-emp-id') == approverId){
                alert('이미 결재 라인에 등록 되었습니다.')
                appendYn = false;
            }
        });
        
        if(!appendYn){
            return false;
        }
        
        var approvalTotalCnt = $approverEl.find('tr').length + 1|| 1;
        
        var indexTDEl = $('<td>', {
            text: approvalTotalCnt + '차 결재'
        });
        
        $addEl.prepend(indexTDEl)
        $addEl.append($('#baseApprDelBtnTd').clone().removeAttr('id'));

        $approverEl.append($addEl);
        
        $('#empSearcModal').modal('hide');
    
    },
    
    deleteAprrover : function(data){
        var $delEl = $(this).closest('tr').remove();
        Regist.indexingTable($('#approvalLineTablebody'), 0);
    
    },
    
    selectSystemList : function(date){
        var sysTpCd = $('input[name=sysTpCd]').val() || ''
        var sysCateId =  $(this).find(':selected').val() || '';
        
        var data = {"sysTpCd" : sysTpCd , "sysCateId" : sysCateId};
        
        var posting = $.post( Regist.SELECT_SYSTEM_URL, data);
        posting.done(function(data){
            Regist.addSystemList(data);
        });
        
    },
    
    addSystemList : function(data){
        var $targetEl = $('#systemSelector');
        $targetEl.find('option').remove().end().append($('<option/>', {'value': '', 'text': '선택' }));
        if(data.length > 0 ){
            for (var i = 0; i < data.length; i++){
                $('<option/>', {
                    'value': data[i].sysId,
                    'text': data[i].sysNm
                }).appendTo($targetEl);
            }
        }
        if ($('#moduleSelector').length){
            $('#moduleSelector option:eq(0)').attr('selected','selected');
        }
        
    },
    
    selectModuleList : function(date){
        var sysId =  $(this).find(':selected').val() || '';
        
        var data = {"sysId" : sysId};
        
        var posting = $.post( Regist.SELECT_MODULE_URL, data);
        posting.done(function(data){
            Regist.addModuleList(data)
        });
        
    },
    
    addModuleList : function(data){
        var $targetEl = $('#moduleSelector');
        $targetEl.find('option').remove().end().append($('<option/>', {'value': '', 'text': '선택' }));
        if(data.length > 0 ){
            $targetEl.prop('disabled', false);
            for (var i = 0; i < data.length; i++){
                $('<option/>', {
                    'value': data[i].modId,
                    'text': data[i].modNm
                }).appendTo($targetEl);
            }
        }else if(data.length < 1 ){
            $targetEl.prop('disabled', true);
        }
        
    },
    
    
    selectITApprovalLine : function(){
        
        var typeId = $('select[name=srTypeId]').val() || ''
        var sysId =  $('select[name=sysId]').val() || '';
        
        if( typeId == 'UA' && (sysId == '100010' || sysId == '110010') ){
            $('#approvalPanel').hide();
            return false;
        }else{
            $('#approvalPanel').show();
        }
        
        var data = {"srTypeId" : typeId , "sysId" : sysId};
        
        var posting = $.post( Regist.APPROVAL_RULE_URL, data);
        posting.done(function(data){
            Regist.addITApprovalLine(data);
            Regist.indexingTable($('#approvalITLineTablebody'), 0);
        });
        
    },
    
    addITApprovalLine : function(data){
        
        var $tgrTable = $('#approvalITLineTablebody');
        $tgrTable.find('tr').remove();
        if(data.length > 0 ){
            for (var i = 0; i < data.length; i++){
                var tempItem = data[i];
                var baseElement = $('#baseEmpTr').clone().removeAttr('id').attr('data-emp-id', tempItem.aprvEmpId).attr('data-dept-id', tempItem.aprvDeptId);
                baseElement.prepend($('<td>'));
                baseElement.find('td.empName').html(tempItem.aprvEmpNm);
                baseElement.find('td.empTitle').html(tempItem.aprvEmpJobTitle);
                baseElement.find('td.deptName').html(tempItem.aprvDeptNm);
                baseElement.append($('#baseApprChangeBtnTd').clone().removeAttr('id'));
                
                $tgrTable.append(baseElement);
                console.log(tempItem.aprvEmpNm);
            }
        
        }else{
            alert('결재선이 없습니다.')
        }
        
    },
    
    setSRDesc : function(){
        Regist.oEditors.getById["reqDesc"].exec("UPDATE_CONTENTS_FIELD", []);
    },
    
    initEditor : function(){
        
        nhn.husky.EZCreator.createInIFrame({
            oAppRef: Regist.oEditors,
            elPlaceHolder: "reqDesc",       // textarea에서 지정한 id와 일치해야 함
            sSkinURI: "/resources/smarteditor/SmartEditor2Skin.html",
            htParams : {
                bUseVerticalResizer : true, // 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)     
                bUseModeChanger : true,     // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
                
                // 에디터 페이지를 벗어날 때의 처리
                fOnBeforeUnload : function(){
                }
            },
            // 아래 함수가 htParams 안으로 들어가면 작동하지 않음
            fOnAppLoad : function(){
                Regist.oEditors.getById["reqDesc"].exec("SE_WYSIWYGEnterKey",['BR']); // PASTE_HTML  
            },
            fCreator: "createSEditor2",
        });
    },
    
    submit : function () {
        
        
        
        Regist.setSRDesc();
        
        if( $('input[name=sysTpCd]').val() == 'SW'){
            if( !Regist.validate()){
                return false;
            }
        }
        
        if( $('input[name=sysTpCd]').val() == 'HW'){
            if( !Regist.validateHW()){
                return false;
            }
        }
            
        
        if(!confirm("저장 하시겠습니까?")) {
            return false;
        }
        
        var srTypeId = $('select[name=srTypeId]').val() || $('input[name=srTypeId]:checked').val();
        if(Regist.isNeedApproval(srTypeId)){
          Regist.setApprovalIdList($('#approvalLineTablebody'), SR_CONST.APPR_TYPE.REQUEST.CODE ,'approvalListJson' );
          Regist.setApprovalIdList($('#approvalITLineTablebody'), SR_CONST.APPR_TYPE.INCHARGE.CODE,'approvalITListJson' );
        }
        
        var frm = document.forms['registerForm'];
        frm.method = "POST";
        frm.action = Regist.REGIST_URL;
        frm.onsubmit = "";
        frm.submit(); 
    },
    
    isNeedApproval : function(srTypeId){
       var index = SR_CONST.NO_APPRVAL_SR_ARR.indexOf(srTypeId);
       var sysId =  $('select[name=sysId]').val() || '';
       
       if( (sysId == '100010' || sysId == '110010') && srTypeId == 'UA'){
           return false;
       }
       
       if(index > -1){
           return false;
       }else{
           return true;
       }
       
    },
    
    showEmpSearchModal : function(e){
        Modal.showEmpSearchModal('apporval');
    },
    
    toggleApprovalLineArea : function(e) {
        var typeId =  $(this).val() || '';
        
        if(Regist.isNeedApproval(typeId)){
            $('#approvalPanel').show();
            var sysId =  $('select[name=sysId]').val() || '';
            if(sysId.length > 3){
                Regist.selectITApprovalLine();
            }
            if(typeId == SR_CONST.SR_TYPE.DATA.CODE){
                $('#addInfoAboutDataSR').show();
            }else{
                $('#addInfoAboutDataSR').hide();
            }
            
        }else{
            $('#approvalPanel').hide();
        }
        
    },
    
    toggleApprovalLineAreaHW : function(e) {
        var typeId =  $(this).val() || '';
        if(Regist.isNeedApproval(typeId)){
            $('#approvalPanel').show();
        }else{
            $('#approvalPanel').hide();
        }
        
    },
    
    
    alertConfData :function(e){
        var val =  $(this).val() || '';
        if( val == 'Y'){
            alert('개인 정보가 포함 된 경우\n 메모 결제 후 해당 결제 결과를 첨부 하여 신청 부탁 드립니다.')
        }
    },
    
    validate : function(e){
        
        var frm = document.forms['registerForm'];
        var srTypeId = frm.elements['srTypeId'].value;
        if(srTypeId.length < 2){
            alert('SR 구분을 선택 해 주세요.') ;
            frm.elements['srTypeId'].focus();
            return false;
        }
        
        if(frm.elements['sysCateId'].value.length < 3){
            alert('시스템 그룹을 선택 해 주세요.') ;
            frm.elements['sysCateId'].focus();
            return false;
        }
        if(frm.elements['sysId'].value.length < 3){
            alert('시스템을 선택 해 주세요.') ;
            frm.elements['sysId'].focus();
            return false;
        }
        
        if( Regist.isNeedApproval(srTypeId) ){
            
            var $approvalLineEl = $('#approvalLineTablebody');
            var $ITapprovalLineEl = $('#approvalITLineTablebody');
            
            if(Regist.cntApprovalIDList($approvalLineEl) < 1){
                alert("승인자를 선택 해주세요.");
                return false;
            }
            if(Regist.cntApprovalIDList($ITapprovalLineEl) < 1){
                alert("IT 승인자가 없습니다.");
                return false;
            }
        }
        
        if(frm.elements['title'].value.length < 3){
            alert('SR 제목을 입력 해주세요.') ;
            frm.elements['title'].focus();
            return false;
        }
        
        if(frm.elements['tgtDttm'].value.length < 3){
            alert('희망 완료일을 선택해주세요.') ;
            frm.elements['tgtDttm'].focus();
            return false;
        }

        if(frm.elements['reqDesc'].value.length < 15){
            alert('요청 내용을 작성해 주세요.') ;
            frm.elements['reqDesc'].focus();
            return false;
        }
        
        return true;
        
    },
    
    validateHW : function(e){
        
        var frm = document.forms['registerForm'];
        var srTypeId = frm.elements['srTypeId'].value;
        if(srTypeId.length < 2){
            alert('요청 구분을 선택 해 주세요.') ;
            frm.elements['srTypeId'].focus();
            return false;
        }
        
        if(frm.elements['sysCateId'].value.length < 3){
            alert('요청 대상을 선택 해 주세요.') ;
            frm.elements['sysCateId'].focus();
            return false;
        }
        if(frm.elements['sysId'].value.length < 3){
            alert('대상 구분을 선택 해 주세요.') ;
            frm.elements['sysId'].focus();
            return false;
        }
        if( $('#moduleSelector').is(':enabled') && frm.elements['modId'].value.length < 3){
            alert('상세 구분을 선택 해 주세요.') ;
            frm.elements['modId'].focus();
            return false;
        }
        
        if(Regist.isNeedApproval(srTypeId) ){
            
            var $approvalLineEl = $('#approvalLineTablebody');
            var $ITapprovalLineEl = $('#approvalITLineTablebody');
            
            if(Regist.cntApprovalIDList($approvalLineEl) < 1){
                alert("승인자를 선택 해주세요.");
                return false;
            }
            if(Regist.cntApprovalIDList($ITapprovalLineEl) < 1){
                alert("IT 승인자가 없습니다.");
                return false;
            }
        }
        
        if(frm.elements['title'].value.length < 3){
            alert('SR 제목을 입력 해주세요.') ;
            frm.elements['title'].focus();
            return false;
        }
        
        if(frm.elements['tgtDttm'].value.length < 3){
            alert('희망 완료일을 선택해주세요.') ;
            frm.elements['tgtDttm'].focus();
            return false;
        }

        if(frm.elements['reqDesc'].value.length < 15){
            alert('요청 내용을 작성해 주세요.') ;
            frm.elements['reqDesc'].focus();
            return false;
        }
        
        return true;
        
    },
    
    cntApprovalIDList : function($target){
        var cnt = 0;
        $target.find('tr').each(function (i) {
            cnt++;
        });
        return cnt;
    },
    
    setApprovalIdList : function($target, type, name){
        
        var aprvListJson = [];
        
        $target.find('tr').each(function (i,el) {
            var $approver=  $(el);
            var aprvEmpId = $approver.attr('data-emp-id');
            var aprvDeptId = $approver.attr('data-dept-id');
            
            aprvListJson.push({
                "aprvEmpId"  : aprvEmpId,
                "aprvDeptId" : aprvDeptId,
                "aprvTpCd" : type
            });
            
        });

        var jsonString= JSON.stringify(aprvListJson);
        $('input[name=' + name +']').val(jsonString); 
        
    } 
}







//]]>